module EzproxyHelper

  # Define a more extensive color palette
  # These colors are similar to the Google Sheets colors
  def ezproxy_colors
    [
      "#3366CC", "#DC3912", "#FF9900", "#109618", "#990099",
      "#3B3EAC", "#0099C6", "#DD4477", "#66AA00", "#B82E2E",
      "#316395", "#994499", "#22AA99", "#AAAA11", "#6633CC",
      "#E67300", "#8B0707", "#329262", "#5574A6", "#651067",
      "#329262", "#5574a6", "#3b3eac", "#b77322", "#16d620",
      "#b91383", "#f4359e", "#9c5935", "#a9c413", "#2a778d",
      "#668d1c", "#bea413", "#0c5922", "#743411", "#3366CC",
      "#DC3912", "#FF9900", "#109618"
    ]
  end

  def ezproxy_requests_and_sessions(model, group, sort_by_value = true)
    # Count the requests for each group, map null to "Unknown"
    requests = model.group(group)
      .sum(:requests)
      .map{|k, v| [k.nil? ? "Unknown" : k, v]}
      .to_h
    # Count the sessions for each group, map null to "Unknown"
    sessions = model.group(group)
      .sum(:sessions)
      .map{|k, v| [k.nil? ? "Unknown" : k, v]}
      .to_h

    # Perform a sort either by descending value or by key
    if sort_by_value
      requests = requests.sort_by{|k,v| -v}
      sessions = sessions.sort_by{|k,v| -v}
    else
      requests = requests.sort_by{|k,v| k}
      sessions = sessions.sort_by{|k,v| k}
    end

    # Return the data structure for requests and sessions
    [
      {
        name: 'Requests',
        data: requests
      },
      {
        name: 'Sessions',
        data: sessions
      }
    ]
  end

  # Get the requests and sessions for the top X entries of the group
  def ezproxy_top_x_data (model, x, group)
    requests = model.group(group)
      .sum(:requests)
      .sort_by{|k,v| -v}
      .first(x)
      .to_h

    sessions = model.group(group)
      .sum(:sessions)
      .select{|k,v| requests.keys.include? k}

    [
      {
        name: "Requests",
        data: requests
      },
      {
        name: "Sessions",
        data: sessions
      }
    ]
  end

  def ezproxy_double_group (model, group_a, group_b)
    # Get the order by descending number of requests
    order_a = model.group(group_a)
      .sum(:requests)
      .sort_by{|k,v| -v}
      .map{|v| [v[0].nil? ? "Unknown" : v[0], []]}
      .to_h

    # Get the order by descending number of requests
    order_b = model.group(group_b)
      .sum(:requests)
      .sort_by{|k,v| -v}
      .map{|v| [v[0].nil? ? "Unknown" : v[0], []]}
      .to_h

    # Build an empty map
    request_groups = order_a.map{ |k,v|
      [
        k,
        order_b.keys.map{|x| [x, 0]}.to_h
      ]
    }.to_h

    # Fetch double grouped information
    requests = model.group(group_a, group_b)
      .sum(:requests)
      .map{|k,v| k.map!{|x| x.nil? ? "Unknown" : x} + [v]}
    # Fill the empty map
    requests.each {|v| request_groups[v[0]][v[1]] = v[2]}

    # Build an empty map
    session_groups = order_a.map{ |k,v|
      [
        k,
        order_b.keys.map{|x| [x, 0]}.to_h
        ]
      }.to_h

    # Get the double grouped information
    sessions = model.group(group_a, group_b)
      .sum(:sessions)
      .map{|k,v| k.map!{|x| x.nil? ? "Unknown" : x} + [v]}
    # Fill the empty map
    sessions.each {|v| session_groups[v[0]][v[1]] = v[2]}

    # Setup data for input into chartkick
    request_data = request_groups.map{|k, v| {name: k, stack: 'A', data: v }}
    session_data = session_groups.map{|k, v| {name: k, stack: 'A', data: v }}

    [request_data, session_data]
  end

end
