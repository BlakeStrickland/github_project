require 'httparty'
require 'byebug'
class User

  def initialize(name, response)
    @name = name
    @repos = response
  end

  def pull_repo_info
    repo_array = []
    begin
      @repos.each do |repo|
        repo_array << {
          name: repo["name"],
          description: repo["description"],
          updated_at: format_updated_time(repo["pushed_at"]),
          language: repo["language"],
          stargazers_url: repo["stargazers_url"],
          stargazers_count: repo["stargazers_count"],
          forks_url: repo["forks_url"],
          forks_count: repo["forks_count"],
          html_url: repo["html_url"],
          original_sort: repo["pushed_at"]
        }
      end
      repo_array.sort_by { |hsh| hsh[:original_sort] }.reverse
    rescue
      [["help"]]
    end
  end

  private

    def self.get_repos(user)
      HTTParty.get("https://api.github.com/users/#{user}/repos")
      # file = "./test/json/results.json"
      # JSON.parse(File.read(file))
    end

    def format_updated_time(updated)
      update_time = Time.parse(updated)
      updated = time_hash(update_time)
      current = time_hash(Time.now)

        #Check if updated this month
      # if updated[:minute] == current[:minute]
      #   difference = current[:second] - updated[:second]
      #   return "Updated #{difference} seconds ago" unless difference == 1
      #   return "Updated a second ago"
      #   #Check if updated today
      # elsif updated[:hour] == current[:hour]
      #   difference = current[:minute] - updated[:minute]
      #   return "Updated #{difference} minutes ago" unless difference == 1
      #   return "Updated a minute ago"
      # elsif updated[:day] == current[:day]
      #   difference = current[:hour] - updated[:hour]
      #   return "Updated #{difference} hours ago" unless difference == 1
      #   return "Updated an hour ago"
      # elsif updated[:month] == current[:month]
      #   difference = current[:day] - updated[:day]
      #   return "Updated #{difference} days ago" unless difference == 1
      #   return "Updated a day ago"
      # else
      #   output = "Updated on #{update_time.strftime("%b")} #{update_time.strftime("%e")}"
      #   output << ", #{update_time.strftime("%Y")}" unless current[:year] == updated[:year]
      # end
      # output

      if updated[:year] == current[:year]
        if updated[:month] == current[:month]
          if updated[:day] == current[:day]
            if updated[:hour] == current[:hour]
              if updated[:minute] == current[:minute]
                #Minutes are equal
                difference = current[:second] - updated[:second]
                return "Updated #{difference} seconds ago" unless difference == 1
                return "Updated a second ago"
              else
                #Hours are equal
                difference = current[:minute] - updated[:minute]
                return "Updated #{difference} minutes ago" unless difference == 1
                return "Updated a minute ago"
              end
            else
              #Days are equal
              difference = current[:hour] - updated[:hour]
              return "Updated #{difference} hours ago" unless difference == 1
              return "Updated an hour ago"
            end
          else
            #Months are equal
            difference = current[:day] - updated[:day]
            return "Updated #{difference} days ago" unless difference == 1
            return "Updated a day ago"
          end
        else
          #Years are equal
        "Updated on #{update_time.strftime("%b")} #{updated[:day]}"
      end
    else
      "Updated on #{update_time.strftime("%b")} #{updated[:day]}, #{updated[:year]}" unless current[:year] == updated[:year]
    end
  end

    def time_hash(time)
      {
          year: time.strftime("%Y").to_i,
          month: time.strftime("%m").to_i,
          day: time.strftime("%e").to_i,
          hour: time.strftime("%H").to_i,
          minute: time.strftime("%M").to_i,
          second: time.strftime("%S").to_i
      }
    end
end
