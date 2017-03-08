require 'tty-prompt'
require 'tty-table'
require 'tty-cursor'

BLANK_SCREEN = <<-VSF

##########################################
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
##########################################
VSF

SELECT_CLIENT_SCREEN = <<-VSF

##########################################
                                          
             Selecione cliente            
                                          
  +--+-----+                              
  |id|nome |                              
  +--+-----+                              
  |1 |Avixy|                              
  |2 |Cielo|                              
  |3 |Rede |                              
  +--+-----+                              
                                          
  ‣ 1                                     
    2                                     
    3                                     
                                          
##########################################
VSF


SERIAL_NUMBER_SCREEN = <<-VSF

##########################################
                                          
                                          
             Entrada de máquina           
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
 Digite a serial ou bipe a máquina:       
                                          
##########################################
VSF

VISUAL_INSPECTION_SCREEN = <<-VSF

##########################################
             Inspeção Visual              
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
 ‣ ⬡ vodka                                
   ⬡ beer                                 
   ⬡ wine                                 
   ⬡ whisky                               
   ⬡ bourbon                              
                                          
##########################################
VSF

@prompt = TTY::Prompt.new
@cursor = TTY::Cursor

GUI = {height: 18, width: 42}

def reset_cursor
  print @cursor.up(GUI[:height]) + @cursor.backward(GUI[:width])
end

def clear_screen
  reset_cursor
  print EXAMPLE_SCREEN % {title: "", content: ""}
end

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

test_display_screens
test_prompt_in_screen

