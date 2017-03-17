require 'tty-prompt'
require 'tty-table'
require 'tty-cursor'

class Cli
end

prompt = TTY::Prompt.new
@cursor = TTY::Cursor

#table_cliente_data = header: ['id', 'nome'], [['1', 'Avixy'], rows: ['2', 'Cielo'], ['3', 'Rede']]
table_cliente_question = "Select CRIENTE"

table_transportador_data = ['Rapidão', 'Mlk']
table_transportador_question = "Select TRNASPORTADORA"

table = TTY::Table.new header: ['id', 'nome'], rows: [['1', 'Avixy'], ['2', 'Cielo'], ['3', 'Rede']]
pergunta = table.render :ascii
pergunta << "\n"
pergunta << table_cliente_question
#resposta = prompt.select pergunta, [1,2,3]
prompt.select table_cliente_question , [1,2,3]



EXAMPLE_SCREEN = <<-VSF

##########################################
   %{title}                               
                                          
 %{content}                               
                                          
                                          
                                          
                                          
                                          
##########################################
VSF

GUI = {height: 11, width: 42}

def reset_cursor
  print @cursor.up(GUI[:height]) + @cursor.backward(GUI[:width])
end

def clear_screen
  reset_cursor
  print EXAMPLE_SCREEN % {title: "", content: ""}
end

print EXAMPLE_SCREEN % {title: "vai toma no cu", content: "fdp"}
sleep 1
print @cursor.up(GUI[:height]) + @cursor.backward(GUI[:width])
sleep 1
print EXAMPLE_SCREEN % {title: "", content: ""}
sleep 1
print @cursor.up(GUI[:height]) + @cursor.backward(GUI[:width])
sleep 1
print EXAMPLE_SCREEN % {title: "oi amigo", content: "tudo bem"}
sleep 1
#print @cursor.clear_screen

clear_screen
reset_cursor
resposta = prompt.select pergunta, [1,2,3]




























