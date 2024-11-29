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

    end)
    IO.inspect r
  end

  # def exec2(code) do
  #   r = Stream.unfold(([], code, 0), )
  # end
end

a = "..+.*:"
b = "11+\"\"\"1+\"****\";"

Runner.exec(a)
