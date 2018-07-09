require 'kumogata2'
require 'kumogata2/cli/option_parser'
require 'kumogata2/logger'
require 'kumogata2/plugin/ruby'

class Kumogata2::Client
  def init(stack_name)
    begin
      base_template = ''
      File.open(Kumogata2::Client::get_template_path('_template'), 'r'){|f|
        base_template = f.read
      }
      raise 'initialize template is empty' if base_template.empty?

      new_template = "#{stack_name}.rb"
      if File.exists? new_template
        print "#{new_template} is already exists. Are sure want to overwrite? [y/N]: "
        answer = STDIN.gets.to_s.chomp
        return nil if answer.upcase != 'Y'
      end

      File.open(new_template, 'w'){|f|
        template = base_template.gsub('#{NAME}', stack_name)
        f.write(template)
      }
      Kumogata2::Logger::Helper.log(:info, "Saved template to #{stack_name}.rb".green)
    rescue => e
      Kumogata2::Logger::Helper.log(:error, "Failed to template #{stack_name} - #{e}".red)
    end
    nil
  end

  def self.get_template_path(file = nil)
    template_path = File.expand_path(File.join(File.dirname(__FILE__),
                                               '..', '..', '..','..', 'template'))
    template_path = File.join(template_path, "#{file}.rb") unless file.nil?
    template_path
  end
end

class Kumogata2::Plugin::Ruby
  def parse(str)
    str = <<EOS
template do
  #{str}
end
EOS
    context = Kumogata2::Plugin::Ruby::Context.new(@options)
    context.instance_eval(str, @options.path_or_url)
    @post = context.instance_variable_get(:@_post)
    context.instance_variable_get(:@_template)
  end
end

class Kumogata2::Plugin::Ruby::Context
  def template(&block)
    key_converter = proc do |k|
      k = k.to_s
      k.gsub!('____', '-')
      k.gsub!('___', '.')
      k.gsub!('__', '::')
      k.gsub!('_', ':')
      k
    end

    value_converter = proc do |v|
      case v
      when Hash, Array
        v
      else
        v.to_s
      end
    end

    @_template = Dslh.eval({
      key_conv: key_converter,
      value_conv: value_converter,
      scope_hook: proc {|scope|
        define_template_func(scope, @options.path_or_url)
      },
      filename: @options.path_or_url,
      ignore_methods: IGNORE_METHODS,
    }, &block)
  end

  private

  def define_template_func(scope, path_or_url)
    functions = ''
    Dir.glob(File.join(Kumogata2::Client::get_template_path, '*.rb')).all? do |file|
      functions << include_func(path_or_url, file)
      functions << "\n\n"
    end

    scope.instance_eval(<<-EOS)
#{functions}

      def _include(file, args = {})
        path = file.dup

        unless path =~ %r|\\A/| or path =~ %r|\\A\\w+://|
          path = File.expand_path(File.join(File.dirname(#{path_or_url.inspect}), path))
        end

        open(path) {|f| instance_eval(f.read) }
      end

      def _path(path, value = nil, &block)
        if block
          value = Dslh::ScopeBlock.nest(binding, 'block')
        end

        @__hash__[path] = value
      end

      def _outputs_filter(&block)
        @__hash__[:_outputs_filter] = block
      end

      def _post(options = {}, &block)
        commands = Dslh::ScopeBlock.nest(binding, 'block')

        @__hash__[:_post] = {
          :options  => options,
          :commands => commands,
        }
      end
    EOS
  end

  def include_func(path_or_url, file)
    <<-EOS
      def _#{get_funcname(file)}(name, args = {})
        args[:name] = name unless args.key? :name

        path = "#{file}"

        unless path =~ %r|\\A/| or path =~ %r|\\A\\w+://|
          path = File.expand_path(File.join(File.dirname(#{path_or_url.inspect}), path))
        end

        open(path) {|f| instance_eval(f.read) }
      end
    EOS
  end

  def get_funcname(file)
    File.basename(file, '.rb').gsub('-', '_')
  end
end
