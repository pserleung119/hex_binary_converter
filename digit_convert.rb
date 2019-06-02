# 定数
BINARY_FORMAT = /[1][0-1*+]/
HEX_FORMAT = /\h/
HEX_ARRAY = {
    "0" => "0",
    "1" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "A" => "10",
    "B" => "11",
    "C" => "12",
    "D" => "13",
    "E" => "14",
    "F" => "15",
}
IS_BINARY = 0
IS_DECIMAL = 1
IS_HEX = 2
MAX_ERROR_COUNT = 3
ASK_INPUT_FORMAT = "What format is the input? [#{IS_BINARY}]=> binary, [#{IS_DECIMAL}]=>decimal, [#{IS_HEX}]=>hexadecimal"
ASK_VALID_INPUT = "Input any valid digit"
ASK_OUTPUT_FORMAT = "What format do you want to convert to? [#{IS_BINARY}]=> binary, [#{IS_DECIMAL}]=>decimal, [#{IS_HEX}]=>hexadecimal"

# グローバル変数
$error_count = 0

def retry_on_error()
    if $error_count < 2
        puts "invalid input, please try again."
        $error_count += 1
    else
        puts "exiting program.."
        exit!
    end
end

def check_selected_format_index()
    while $error_count < MAX_ERROR_COUNT do
        format_index = gets.to_i
        correct_index = (format_index >= 0) && (format_index <= 2)

        if !correct_index
            retry_on_error()
        else
            return format_index
        end
    end
end

def get_valid_input(format_index)

    while $error_count < MAX_ERROR_COUNT do
        input = gets.chomp
        is_error = true

        case format_index
        when IS_BINARY then
            if (BINARY_FORMAT.match(input))
                is_error = false
            end
        when IS_DECIMAL then
            if input.to_i.to_s == input
                is_error = false
            end
        when IS_HEX then
            if (HEX_FORMAT.match(input))
                is_error = false
            end
        end

        # 結果に応じて返り値を決める
        if is_error
            retry_on_error()
        else
            return input
        end
    end
end

def convert_to_decimal(input_value, input_format)

    # 出力値の初期化
    decimal_value = 0

    if input_format == IS_BINARY
        # 1桁目から計算するため、値を逆順で配列に入れる
        # first digit = 0 due to array structure
        input_value_array = input_value.reverse.split("")
        input_value_array.count.times do |digit|
            decimal_value = decimal_value + (input_value_array[digit].to_i * (2 ** digit.to_i))
        end

    elsif input_format == IS_DECIMAL
        decimal_value = input_value

    elsif input_format == IS_HEX
        input_value_array = input_value.reverse.split("")
        input_value_array.count.times do |digit|
            decimal_value = decimal_value + (HEX_ARRAY[input_value_array[digit].upcase].to_i * (16 ** digit.to_i))
        end
    end

    return decimal_value
end

def convert_from_decimal(input_value, output_format)

    if output_format == IS_BINARY
        output_array = []
        digit = 0
        while input_value > 0
            output_array[digit] = input_value % 2 == 0 ? 0 : 1
            input_value = input_value / 2
            digit += 1
        end
        output_value = output_array.reverse.join

    elsif output_format == IS_DECIMAL
        output_value = input_value

    elsif output_format == IS_HEX
        output_array = []
        power_value = 0

        while input_value > 0 do

            # 該当桁の値を計算
            hex_count = input_value / (16 ** power_value)

            # 計算し値が該当枠に全て納まるかどうかを判定
            has_next_digit = hex_count >= 16

            # 該当桁でも納まらない場合は次の桁から生じた余りをその桁に格納
            if (has_next_digit)
                this_digit_value = hex_count % 16
                output_array[power_value] = HEX_ARRAY.keys[this_digit_value]

                input_value = input_value - (this_digit_value * (16 ** power_value))

            # 該当枠で納まる場合は当てはまる16位数を格納し、ループから抜け出す
            else
                output_array[power_value] = HEX_ARRAY.keys[hex_count]
                break
            end
            power_value += 1
        end
        output_value = output_array.reverse.join
    end

    return output_value
end

puts ASK_INPUT_FORMAT
input_format_index = check_selected_format_index()

puts ASK_VALID_INPUT
input = get_valid_input(input_format_index)

puts ASK_OUTPUT_FORMAT
output_format_index = check_selected_format_index()

if output_format_index == input_format_index
    # 変換がない場合はinputをそのまま出力
    puts "Output: #{input.to_s}"
else
    tmp_value = convert_to_decimal(input, input_format_index)
    output = convert_from_decimal(tmp_value, output_format_index)
    puts "Output: #{output.to_s}"
end
