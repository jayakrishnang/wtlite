require 'csv'

class TimeLoad
  attr_accessor :date, :recurring, :name, :file_path

  def initialize(date=DateTime.now, recurring=nil)
    @date = date
    @recurring = recurring
    @name = ENV['NAME']
    gather_file
  end

  def gather_file
    files = Dir.glob(ENV['SOURCEDIRECTORY'] + ENV['PROJECT'] + '*')
    @file_path = files.select { |file| !TrackerFile.where(filename: file).exists? }.compact.first
  end

  def load_time
    puts "Run at #{DateTime.now}"
    if @file_path.blank?
      puts 'No new file'
    else
      TrackerFile.create(filename: @file_path)
      start_date = @date.utc.beginning_of_month
      end_date = @date.utc.end_of_month

      table = CSV.parse(File.read(@file_path), headers: true)
      result = table.select {|row| row['Owned By'] == @name && (DateTime.parse(row['Started At'] || '0001-01-01').between?(start_date, end_date)) }
      result = result.sort_by {|obj| DateTime.parse(obj['Started At']) }
      result.each do |res|
        story = Story.where(uid: res['Id']).first
        total_time = get_time(res['Owner BT Recorded'])
        log_date = @recurring ? Date.today : DateTime.parse(res['Started At']).to_date
        if story.present? && story.time_added?(total_time)
          puts "Existing story #{story.id}"
          log = story.logs.where(log_date: log_date).first_or_create
          log.update(time: total_time - story.total_time)
          story.update(total_time: total_time)
        elsif story.blank?
          puts "New story #{res['Id']}"
          story = Story.create(title: res['Story Title'], uid: res['Id'], url: res['URL'], total_time: tot)
          story.logs.create(log_date: log_date, time: total_time)
        else
          puts "Story: #{story.title} had time #{story.total_time.format}"
        end
      end
      replace_extension_html
    end
  end

  def get_time(value)
    result = 0
    result += value.split(':').first.to_i * 3600
    result += value.split(':').second.to_i * 60
    result += value.split(':').third.to_i
    result
  end

  def replace_extension_html
    puts 'Replacing file....'
    content = File.read('public/browser_action_template.html')
    content = content.gsub('DAILY_HOURS', Log.today.summary.to_s)
    content = content.gsub('MONTH_HOURS', Log.this_month.summary.to_s)
    tickets_summary = []
    Log.where('log_date >= ? AND log_date <= ?', Date.today, Date.today).each do |log|
      tickets_summary << "<p> #{log.story.uid} | #{log.story.title} | #{log.time.format} </p>"
    end
    content = content.gsub('TICKETS', tickets_summary.join('\n\t\t\t\t'))
    puts content
    File.open(ENV['CHROME_EXTENSION_PATH'], "w+") do |f|
      f.write(content)
    end
  end
end
