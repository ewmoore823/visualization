/*class cmvHeat {
  Cell[][] grid;
  
  List<String> uniq_times;
  List<String> uniq_ports;
  List<String> uniq_src_ips;
  float posx, posy, w, h;
  
  float highest_count; // used to determine density of colors.
  cmvHeat(float x, float y, float wt, float ht, String[][] raw_data, List<String> uniq_src_ips1, List<String> uniq_times1, List<String> uniq_ports1) {
    posx = x;  posy = y;
    w    = wt; h = ht;
    uniq_times = new ArrayList<String>(uniq_times1);
    uniq_ports = new ArrayList<String>(uniq_ports1);
    uniq_src_ips = new ArrayList<String>(uniq_src_ips1);
    highest_count = 0;
    init_data();
    transform_and_load_data(raw_data);
    assign_cell_colors();
  }
  
  void init_data() {
    int j, i;
    float cell_x, cell_y;
    float cell_width = w / float(uniq_times.size());
    float cell_height = h / float(uniq_ports.size());
    grid = new Cell[uniq_times.size() + 1][uniq_ports.size() + 1];
    // Draw Grid w/ data
    for (i=1; i<uniq_times.size() + 1; i++) {
      for (j=0; j<uniq_ports.size(); j++) {
        cell_x = w * (i / float(uniq_times.size()));
        cell_y = h * (2.73 + (j / float(uniq_ports.size()))); // XXX PLACE THIS BETTER
        grid[i][j] = new Cell(cell_x, cell_y, cell_width, cell_height, "", uniq_src_ips.size());
      }
    }
    //Draw X-Axis Labels
    j = uniq_ports.size();
    cell_y = h * (2.73 + (j / float(uniq_ports.size()))); // XXX PLACE THIS BETTER
    for (i=1; i<uniq_times.size(); i++) {
      cell_x = w * (i / float(uniq_times.size()));
      grid[i][j] = new Cell(cell_x, cell_y, cell_width, cell_height, uniq_times.get(i-1), uniq_src_ips.size());
    }
    //Draw Y-Axis Labels
    i=0;
    cell_x = w * (i / float(uniq_times.size()));
    for (j=0; j < uniq_ports.size(); j++) {
      cell_y = h * (2.73 + (j / float(uniq_ports.size()))); // XXX PLACE THIS BETTER
      grid[i][j] = new Cell(cell_x, cell_y, cell_width, cell_height, uniq_ports.get(j), uniq_src_ips.size());
    }
  }
  void transform_and_load_data(String[][] raw_data) {
    for (int i=0; i< raw_data.length; i++) {
      int time_range = uniq_times.indexOf(raw_data[i][TIME_STAMP]) + 1;
      int port_range = uniq_ports.indexOf(raw_data[i][SRC_PORT]);
      int src_ip_range = uniq_src_ips.indexOf(raw_data[i][SRC_IP]);
      grid[time_range][port_range].count += 1;
      if (grid[time_range][port_range].count > highest_count) {
        highest_count = grid[time_range][port_range].count;
      }
      check_all_fields(grid[time_range][port_range], raw_data[i], src_ip_range);
    }
  }
  
  void check_all_fields(Cell curr_cell, String[] curr_element, int src_ip_range) {
    curr_cell.source_ips[src_ip_range] = true;
    if (curr_element[PROTOCOL].equals("TCP")) { curr_cell.tcp = true; }
    else if (curr_element[PROTOCOL].equals("UDP")) { curr_cell.udp = true; }
    
    if (curr_element[OP].equals("Teardown")) { curr_cell.teardown = true; }
    else if (curr_element[OP].equals("Deny")) { curr_cell.deny = true; }
    else if (curr_element[OP].equals("Built")) { curr_cell.built = true; }
    
    if (curr_element[SYSLOG].equals("Info")) { curr_cell.info = true; }
  }
  
  void assign_cell_colors() {
    colorMode(HSB, 360, 100, 100);
    for (int i=1; i<uniq_times.size() + 1; i++) {
      for (int j=0; j<uniq_ports.size(); j++) {    
        float ratio = grid[i][j].count / highest_count;
        float adjusted_color = sqrt(ratio);
        if (ratio > 0) {
          adjusted_color = max(10, sqrt(ratio)*100);
        }
        grid[i][j].set_heat_color(color(240, adjusted_color, 100)); 
      }
    }
    colorMode(RGB, 255, 255, 255);
  }

  // 
  //  PUBLIC METHODS FOR INTERACTION finding hover/displaying highlighting 
  // 
  cmvFilter check_hover() {
    cmvFilter new_filter = null;
    for (int i=1; i<uniq_times.size() + 1; i++) {
      for (int j=0; j<uniq_ports.size(); j++) {
        if (grid[i][j].rct.within()) {
          new_filter = new cmvFilter(HEAT, "", "", uniq_ports.get(j), uniq_times.get(i-1));
        }
      }
    }
    return new_filter;
  }
  void update(cmvFilter curr_filter) {
    
    //re-assign x, y, width, height and color in rect
    for (int i=0; i<uniq_times.size() + 1; i++) {
      for (int j=0; j<uniq_ports.size() + 1; j++) {
        if (i == 0) { continue; }
        if (j == uniq_ports.size()) { continue; }
        grid[i][j].display_heat();
        if (curr_filter != null) {
          if (curr_filter.magic_chart == CATEGORY) {
            if (curr_filter.category.equals("udp") && grid[i][j].udp == true) {
              grid[i][j].display_highlight();
            }
            else if (curr_filter.category.equals("tcp") && grid[i][j].tcp == true) {
              grid[i][j].display_highlight();
            }
            else if (curr_filter.category.equals("built") && grid[i][j].built == true) {
              grid[i][j].display_highlight();
            }
            else if (curr_filter.category.equals("teardown") && grid[i][j].teardown == true) {
              grid[i][j].display_highlight();
            }
            elseif (curr_filter.category.equals("deny") && grid[i][j].deny == true) {
              grid[i][j].display_highlight();
            }
            else if (curr_filter.category.equals("info") && grid[i][j].info == true) {
              grid[i][j].display_highlight();
            }
          }
          else if (curr_filter.magic_chart == NETWORK) {
            if (grid[i][j].source_ips[uniq_src_ips.indexOf(curr_filter.source_ip)]) {
              grid[i][j].display_highlight();
            }
          }
          else {
            grid[i][j].display_heat();
          }
        }
      }
    }
  }
}
*/
