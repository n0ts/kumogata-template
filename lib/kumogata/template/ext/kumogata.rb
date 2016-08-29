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

  def evaluate_template(template, path_or_url)
    key_converter = proc do |key|
      key = key.to_s
      unless @options.skip_replace_underscore?
        key.gsub!('_', ':')
        key.gsub!('__', '::')
      end
      key
    end

    value_converter = proc do |v|
      case v
      when Hash, Array
        v
      else
        v.to_s
      end
    end

    template = Dslh.eval(template.read, {
      :key_conv   => key_converter,
      :value_conv => value_converter,
      :scope_hook => proc {|scope|
        define_template_func(scope, path_or_url)
      },
      :filename   => path_or_url,
    })

    @outputs_filter.fetch!(template)
    @post_processing.fetch!(template)

    return template
  end

  def devaluate_template(template)
    exclude_key = proc do |k|
      k = k.to_s.gsub('::', '__')
      k !~ /\A[_a-z]\w+\Z/i and k !~ %r|\A/\S*\Z|
    end

    key_conv = proc do |k|
      k = k.to_s

      if k =~ %r|\A/\S*\Z|
        proc do |v, nested|
          if nested
            "_path(#{k.inspect}) #{v}"
          else
            "_path #{k.inspect}, #{v}"
          end
        end
      else
        k.gsub(':', '_')
        k.gsub('::', '__')
      end
    end

    value_conv = proc do |v|
      if v.kind_of?(String) and v =~ /\A(?:0|[1-9]\d*)\Z/
        v.to_i
      else
        v
      end
    end

    Dslh.deval(template, :key_conv => key_conv, :value_conv => value_conv, :exclude_key => exclude_key)
  end
end
