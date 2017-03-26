require 'tty-prompt'
require 'tty-table'
require 'tty-cursor'

class Cli2

  BLANK_SCREEN = <<-VSF

  ##########################################
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
  ##########################################
  VSF

  MODEL_SCREEN = <<-VSF

  ##########################################
    %{topcontent}                           
    %{title}                                
                                            
    %{content}                              
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
    %{lowcontent}                           
                                            
  ##########################################
  VSF

  GUI = {height: 18, width: 42}

  @prompt = TTY::Prompt.new
  @cursor = TTY::Cursor

  def draw(h={})
    topcontent = h[:topcontent] || ""
    title      = h[:title]      || ""
    content    = h[:content]    || ""
    lowcontent = h[:lowcontent] || ""

    print MODEL_SCREEN % {
      topcontent: topcontent,
      title: title,
      content: content,
      lowcontent: lowcontent,
    }
  end

  def clear_screen
    system "clear"
  end

  def blank_screen
    clear_screen
    print BLANK_SCREEN
  end

  def reset_cursor
    print @cursor.up(GUI[:height]) + @cursor.backward(GUI[:width])
  end

end


#def clear_screen
  #reset_cursor
  #print EXAMPLE_SCREEN % {title: "", content: ""}
#end

def test_display_screens
  print SELECT_CLIENT_SCREEN
  sleep 1
  reset_cursor
  print BLANK_SCREEN
  sleep 1
  reset_cursor
  print SERIAL_NUMBER_SCREEN
  sleep 1
  reset_cursor
  print BLANK_SCREEN
  sleep 1
  reset_cursor
  print VISUAL_INSPECTION_SCREEN
  sleep 1
end

def test_prompt_in_screen
  reset_cursor
  print BLANK_SCREEN
  reset_cursor
  print @cursor.down 2
  @prompt.select 'Select CRIENTE', [1,2,3]
end

def test_display_screens2
  cli2 = Cli2.new
  cli2.blank_screen
  sleep 1
  cli2.clear_screen
  sleep 1
  cli2.draw title: "bbbbbb",
    topcontent: "bbb",
    content: "blabalbalblababla",
    lowcontent: "bbbb"
end

def test_prompt_in_screen
  
end

test_display_screens2

#test_display_screens2
#test_prompt_in_screen2

