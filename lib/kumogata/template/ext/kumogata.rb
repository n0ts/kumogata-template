require 'kumogata'
require 'kumogata/argument_parser'

class Kumogata::Client
  def init(stack_name)
    begin
      base_template = ''
      File.open(get_template_path('_template'), 'r'){|f|
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
      Kumogata.logger.info("Saved template to #{stack_name}.rb".green)
    rescue => e
      Kumogata.logger.info("Failed to template #{stack_name} - #{e}".red)
    end
    nil
  end

  def define_template_func(scope, path_or_url)
    functions = ''
    Dir.glob(File.join(get_template_path, '*.rb')).all? do |file|
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


  private  ###########################################################

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

  def get_template_path(file = nil)
    template_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..','..', 'template'))
    template_path = File.join(template_path, "#{file}.rb") unless file.nil?
    template_path
  end
end
