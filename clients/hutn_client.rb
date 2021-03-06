require "httparty"

class Evaluator
  def initialize(url)
    @url = url
  end
  
  def run(hutn)

    # Exercise the SUT
    new_instance = HTTParty.post(@url, body: { instance: { input_model: hutn } } )
  
    id = new_instance["id"]
    coverage_url = @url.chomp(".json") + "/#{id}.json"
    
    puts "Instantiated SUT, creating instance \##{id}."
    puts "Polling for results at: #{coverage_url}"


    # Wait for coverage results
    results = HTTParty.get(coverage_url)
    until results["coverage"] or results["error"] do
      puts "Coverage not yet ready, waiting for 1 second before retrying"
      sleep 1
      results = HTTParty.get(coverage_url)
    end

    if results["coverage"]
      puts results["coverage"].split(" ").map(&:to_i).to_s  # [0,1,0,...]
    else
      puts "Error encountered: " + results["error"]
    end
  end
end

hutn = File.read(File.join(File.dirname(__FILE__), "wildebeest.hutn"))
Evaluator.new("http://transformations.herokuapp.com/transformations/2/instances.json").run(hutn)




