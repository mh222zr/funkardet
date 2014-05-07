module GroupDateHelpers
  def visit_group(group)
    visit "/groups"
    within "#group_#{group.id}" do
      click_link "List Dates"
    end
  end

  def create_group_date(options={})
    options[:name] ||= "Testdate"
    options[:place] ||= "Placetest"
    options[:from_date] ||= DateTime.now
    options[:to_date] ||= DateTime.now
    options[:description] ||= "A sample text"

    click_link "New Group Date"

    fill_in "Name", with: options[:name]
    fill_in "Place", with: options[:place]

    select_date_and_time(options[:from_date], prefix: "group_date", from: :from_date)
    select_date_and_time(options[:to_date], prefix: "group_date", from: :to_date)

    fill_in "Description", with: options[:description]

    click_button "Save"
  end
end