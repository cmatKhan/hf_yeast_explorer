library(tidyverse)

curr_input = read_csv("~/htcf_local/cc/yeast/all_input.csv")

data_subdirs = list.dirs("~/htcf_local/cc/yeast/data")
all_fastq = read_csv("~/htcf_local/cc/yeast/fastq_lookup.txt", col_names='fastq')

input_df = all_fastq %>%
    filter(str_detect(fastq, "data/run_7382", negate=TRUE),
           str_detect(fastq, "fastqc", negate=TRUE)) %>%
    mutate(sample = basename(dirname(fastq))) %>%
    mutate(tmp = ifelse(str_detect(fastq, "R1"), "fastq_1", "fastq_2")) %>%
    pivot_wider(id_cols = sample, names_from = tmp, values_from = fastq) %>%
    mutate(barcode_details = file.path("data", sample, paste0(sample, "_barcode_details.json"))) %>%
    mutate(barcode_details = str_replace(barcode_details,
                                         "run_5690_correct_barcode_details.json",
                                         "run_5690_barcode_details.json"))


setdiff(basename(data_subdirs), input_df$sample)


# input_df %>%
#     filter(!sample %in% curr_input$sample) %>%
# write_csv("~/htcf_local/cc/yeast/reamining_input.csv")
