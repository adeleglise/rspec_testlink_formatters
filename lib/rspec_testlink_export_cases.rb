require "time"
require "builder"
require "rspec"

require "rspec/core/formatters/base_formatter"
class RspecTestlinkExportCases < RSpec::Core::Formatters::BaseFormatter
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

  def examples
    @examples_notification.notifications
  end

  def xml
    @xml ||= Builder::XmlMarkup.new target: output, indent: 2
  end

  def xml_dump
	  xml.instruct!
	  xml.testcases do
		  examples.each do |example|
			  xml.testcase name: example.example.description.split('|')[0].strip do
				  xml.summary(example.example.location)
				  xml.status(1)
				  xml.execution_type(2)
				  xml.requirements do
					  xml.requirement do
						  xml.doc_id(example.example.example_group.description.split('|')[1].strip)
					  end
				  end
				  xml.custom_fields do
					  xml.custom_field do
						  xml.name('RSPEC CASE ID')
						  xml.value(example.example.description.split('|')[1].strip)
					  end
				  end
			  end
		  end
	  end
  end
end

