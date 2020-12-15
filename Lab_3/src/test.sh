#!/bin/bash
make guest

./string_manipulation.out rand_str_input_sec

diff ./samples/concat_sec rand_str_input_sec_concat_out
diff ./samples/sorted_sec rand_str_input_sec_sorted_out
diff ./samples/len_sec rand_str_input_sec_len_out

./string_manipulation.out rand_str_input.txt


diff ./samples/concat_txt rand_str_input.txt_concat_out
diff ./samples/sorted_txt rand_str_input.txt_sorted_out
diff ./samples/len_txt rand_str_input.txt_len_out

make clean
