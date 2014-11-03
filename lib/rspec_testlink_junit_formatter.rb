require "time"

require "builder"
require "rspec"

require "rspec/core/formatters/base_formatter"

# Dumps rspec results as a JUnit XML file.
# Based on XML schema: http://windyroad.org/dl/Open%20Source/JUnit.xsd
class RspecTestlinkJunitformatter < RSpec::Core::Formatters::BaseFormatter

  RSpec::Core::Formatters.register self,
    :start,
    :stop,
    :dump_summary

  def start(notification)
    @start_notification = notification
    @started = Time.now
    super
  end

  def stop(notification)
    @examples_notification = notification
  end

  def dump_summary(notification)
    @summary_notification = notification
    xml_dump
  end

private

  attr_reader :started

  def example_count
    @summary_notification.examples.count
  end

  def failure_count
    @summary_notification.failed_examples.count
  end

  def duration
    @summary_notification.duration
  end

  def examples
    @examples_notification.notifications
  end

  def result_of(notification)
    notification.example.execution_result[:status]
  end

  def classname_for(notification)
    notification.example.file_path.sub(%r{\.[^/]*\Z}, "").gsub("/", ".").gsub(%r{\A\.+|\.+\Z}, "")
  end

  def duration_for(notification)
    notification.example.execution_result[:run_time]
  end

  def description_for(notification)
    notification.example.full_description
  end

  def exception_for(notification)
    notification.example.execution_result[:exception]
  end

  def formatted_backtrace_for(notification)
    backtrace = notification.formatted_backtrace
  end

private

  def xml
    @xml ||= Builder::XmlMarkup.new target: output, indent: 2
  end

  def xml_dump
    xml.instruct!
    xml.testsuite name: "rspec", tests: example_count, failures: failure_count, errors: 0, time: "%.6f" % duration, timestamp: started.iso8601 do
      xml.properties
      xml_dump_examples
    end
  end

  def xml_dump_examples
    examples.each do |example|
      send :"xml_dump_#{result_of(example)}", example
    end
  end

  def xml_dump_passed(example)
    xml_dump_example(example)
  end

  def xml_dump_pending(example)
    xml_dump_example(example) do
      xml.skipped
    end
  end

  def xml_dump_failed(example)
    exception = exception_for(example)
    backtrace = formatted_backtrace_for(example)

    xml_dump_example(example) do
      xml.failure message: exception.to_s, type: exception.class.name do
        xml.cdata! "#{exception.message}\n#{backtrace.join "\n"}"
      end
    end
  end

  def xml_dump_example(example, &block)
    xml.testcase classname: classname_for(example), name: example.example.description.split('|')[1].strip, time: "%.6f" % duration_for(example), &block
  end
end

