require 'rest-client'
require 'json'

def get_names
  response = RestClient.get('https://swapi.co/api/people')
  data = JSON.parse(response.body)
  data["results"].map {|character| character["name"]}
end
get_names

def get_weight
  response = RestClient.get('https://swapi.co/api/people')
  data = JSON.parse(response.body)
  weight = data["results"].map {|character| character["mass"]}
  weight.reduce {|a,b| a.to_i + b.to_i}
end
get_weight

def print_starships
  url = 'https://swapi.co/api/starships'
  starships = []
  begin
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    starships.concat(data["results"].map {|starship| starship["name"]})
    url = data["next"]
  end while url != nil
  starships
end
print_starships

def cost_of_ships
  url = 'https://swapi.co/api/starships'
  costs = []
  begin
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    costs.concat(data["results"].map {|starship| starship["cost_in_credits"]})
    url = data["next"]
  end while url != nil
  total = costs.reduce {|a,b| a.to_i + b.to_i}
end
cost_of_ships

def avg_cost_of_ships
  url = 'https://swapi.co/api/starships'
  costs = []
  begin
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    costs.concat(data["results"].map {|starship| starship["cost_in_credits"]})
    url = data["next"]
  end while url != nil
  avg = (costs.reduce {|a,b| a.to_i + b.to_i}) / costs.size
end
avg_cost_of_ships

def read_file
  people = IO.readlines('people.csv')
  keys = people.shift.split(',')
  list = []
  list = people.map { |line|
    new_hash = {}
    person = line.split(',')
    person.each_with_index {|value, index|
      new_hash[keys[index].strip] = value.strip
    }
    new_hash
  }
  list
end
read_file

list_people = read_file
def num_men_women(array)
  genders = array.group_by { |element| element["gender"] }
  genders.each {|key, value| genders[key] = value.count}
end
num_men_women(list_people)

def born_after_year(array, year)
  filtered = array.select {|person| person["dob"].split('-')[0].to_i > year}
  filtered.map {|person| person["given_name"] + ' ' + person["surname"]}
end
born_after_year(list_people, 2000)

def save_response
  url = 'https://swapi.co/api/starships'
  response = RestClient.get(url)
  data = JSON.parse(response.body)
  open('myfile.txt', "w") { |f| f << data }
end
save_response

