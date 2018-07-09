require 'minitest/autorun'
require 'kumogata2'
require 'kumogata2/cli/option_parser'
require 'kumogata2/plugin/ruby'
require 'json'
require 'tempfile'
require 'yaml'
require 'kumogata/template/const'

# for only test
ENV['TZ'] = 'Asia/Tokyo'

class Kumogata2::Plugin::Ruby::Context
  remove_method :define_template_func
  def define_template_func(scope, path_or_url)
    functions = ""
    Dir.glob("template/*.rb").all? do |file|
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
        open("#{file}") {|f| instance_eval(f.read) }
      end
    EOS
  end

  def get_funcname(file)
    File.basename(file, '.rb').gsub('-', '_')
  end
end


def tempfile(content, template_ext = nil)
  basename = "#{File.basename __FILE__}.#{$$}"
  basename = [basename, template_ext] if template_ext

  content = <<EOS
template do
  #{content}
end
EOS
  Tempfile.open(basename) do |f|
    f << content
    f.flush
    f.rewind
    yield(f)
  end
end

def run_client(template)
  $stdout = open('/dev/null', 'w') unless ENV['DEBUG']

  Kumogata2::Plugin.load_plugins

  options = Kumogata2::CLI::OptionParser::DEFAULT_OPTIONS
  options[:output_format] = 'json'
  options[:result_log] = '/dev/null'
  options[:command_result_log] = '/dev/null'
  template_ext = '.rb'

  template = tempfile(template, template_ext) do |f|
    Kumogata2::Client.new(options).send(:open_template, f.path)
  end
end

def run_client_as_json(template)
  eval_template = run_client(template)
  JSON.pretty_generate(eval_template)
end

def run_client_as_yaml(template)
  eval_template = run_client(template)
  YAML.dump(eval_template)
end
