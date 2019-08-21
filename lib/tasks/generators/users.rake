namespace :generators do
        desc "Generate Users"
        task :users => :environment do
            puts "Generating users..."
            File.open("tmp/users.csv", "r").each_line do |line|
                data = line.split(":")

                User.create!(
                      {
                          email: data[0],
                          password: "123456",
                          fullname: data[2],
                          male: data[3] == "Muz",
                          primary_claim: find_place(data[4]) ,
                          secondary_claim: find_place(data[5]),
                          room_type: data[1]
                      }
                )
            end
            puts "Generated successfully"
        end

        def find_place(room)
          if room.blank?
            nil
          else
            place = Place.where(room: room).first
            if place.nil?
              puts "Ignoring room #{room}"
            else
              puts "OK #{room}"
            end
            place
          end
        end
end