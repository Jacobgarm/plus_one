defmodule Runner do
  def exec(code) do
    r = Enum.reduce(String.codepoints(code), [], fn(symb,acc) -> 
      case symb do
        "1" -> [1 | acc]
        "+" -> [(hd acc) + (hd tl acc) | tl tl acc]
        "*" -> [(hd acc) * (hd tl acc) | tl tl acc]
        "\"" -> [(hd acc) | acc]
        "/" -> (tl acc) ++ [hd acc]
        "\\" -> [(hd Enum.take(acc, -1)) | Enum.take(acc, length(acc)-1)]
        "^" -> [(hd tl acc) | [(hd acc) | tl tl acc]]
        "<" -> [(if ((hd acc) > (hd tl acc)) do 0 else 1 end)| tl tl acc]
        "." -> [String.to_integer(String.replace(IO.gets(""), "\n", "")) | acc]
        "," -> [(hd String.to_charlist(String.replace(IO.gets(""), "\n", ""))) | acc]
        ":" -> (
          IO.puts hd acc;
          tl acc
        )
        ";" -> (
          IO.puts <<(hd acc)::utf8>>;
          tl acc
        )
        _ -> acc
      end

    end)
    IO.inspect r
  end

  def exec2(code) do
    Stream.unfold({[], code, 0, false}, fn {acc, code, ip, in_comment} ->
      if ip == String.length(code) do
        nil
      else
        symb = String.at(code, ip)

        if in_comment do
          if symb == "]" do
            {0, {acc, code, ip+1, false}}
          else
            {0, {acc, code, ip+1, true}}
          end
        else if symb == "#" do
          new_ip = Enum.reduce_while(0..String.length(code), 0, fn(i, num) -> 
            if String.at(code, i) == "#" do 
              if num == hd acc do
                {:halt, i}
              else 
                {:cont, num+1}
              end
            else
                {:cont, num}
            end
          end)
          {0, {(tl acc), code, new_ip + 1, in_comment}}
        else
          res = case symb do
            "1" -> [1 | acc]
            "+" -> [(hd acc) + (hd tl acc) | tl tl acc]
            "*" -> [(hd acc) * (hd tl acc) | tl tl acc]
            "\"" -> [(hd acc) | acc]
            "/" -> (tl acc) ++ [hd acc]
            "\\" -> [(hd Enum.take(acc, -1)) | Enum.take(acc, length(acc)-1)]
            "^" -> [(hd tl acc) | [(hd acc) | tl tl acc]]
            "<" -> [(if ((hd acc) < (hd tl acc)) do 0 else 1 end)| tl tl acc]
            "." -> [String.to_integer(String.replace(IO.gets(""), "\n", "")) | acc]
            "," -> [(hd String.to_charlist(String.replace(IO.gets(""), "\n", ""))) | acc]
            ":" -> (
              IO.puts hd acc;
              tl acc
            )
            ";" -> (
              IO.puts <<(hd acc)::utf8>>;
              tl acc
            )
             _ -> acc
          end
          {0, {res, code, ip+1, in_comment}}
          end
        end
      end
    end) |> Stream.run()
  end
end

a = ".111##^\"/*\\1+\\<1+#"
b = "11+\"\"\"1+\"****\";"
c = File.read!("fibonacci.one")

Runner.exec2(c)
