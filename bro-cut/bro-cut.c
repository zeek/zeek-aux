#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define MAX_LINE 16384

int string_index(char *haystack[], int haystack_size, char *needle) {
    int i;
    for(i=0; i < haystack_size ; ++i) {
        if(strcmp(haystack[i], needle) == 0) {
            return i;
        }
    }
    return -1;
}

int max_index(int *indexes, int num_indexes) {
    int i;
    int ret = 0;
    for(i=0; i < num_indexes; ++i) {
        if(indexes[i] > ret) {
            ret = indexes[i];
        }
    }
    return ret;
}

const char *tmp_fields[MAX_LINE];

void output_indexes(char *line, int *indexes, int num_indexes, char *ofs) {
    int i;
    int cur_field = 0;
    char * field;
    char *_ofs = "\0";

    int highest_index = max_index(indexes, num_indexes) +1;

    for(i=0; i < highest_index; ++i) {
        field = strsep(&line, "\t");
        tmp_fields[i] = field;
    }
    for(i=0; i < num_indexes ; ++i) {
        if(indexes[i] == -1) {
            printf("%s", _ofs);
        } else {
            printf("%s%s", _ofs, tmp_fields[indexes[i]]);
        }
        ++cur_field;
        _ofs = ofs;
    }
    printf("\n");
}

int find_output_indexes(int **output_indexes, int num_columns, char *columns[], int negate, char *line) {
    int i;
    int *out_indexes;

    int num_fields = 0;
    char *fields_line = strdup(line+8);
    char *field;

    while((field = strsep(&fields_line, "\t")) != NULL) {
        num_fields++;
    }
    char **fields=(char **) malloc(num_fields*sizeof(char *));
    int idx = 0;
    fields_line = strdup(line+8);
    while((field = strsep(&fields_line, "\t")) != NULL) {
        fields[idx++] = strdup(field);
    }

    /* All the columns */
    if(num_columns == 0){
        out_indexes=(int *) malloc(num_fields*sizeof(int));
        for(i=0; i < num_fields ; ++i) {
            out_indexes[i] = i;
        }
        *output_indexes = out_indexes;
        return num_fields;
    }
    fields_line = strdup(line+8);
    if(!negate) {
        out_indexes=(int *) malloc(num_columns*sizeof(int));
        int idx = 0;
        int out_idx = 0;
        int fields_idx ;
        for(idx = 0 ; idx < num_columns ; ++idx) {
            if((fields_idx = string_index(fields, num_fields, columns[idx])) != -1) {
                out_indexes[out_idx++] = fields_idx;
            } else {
                out_indexes[out_idx++] = -1;
            }
        }
        *output_indexes = out_indexes;
        return out_idx;
    } else {
        out_indexes=(int *) malloc((num_fields-num_columns)*sizeof(int));
        int idx = 0;
        int out_idx = 0;
        for(idx = 0 ; idx < num_fields ; ++idx) {
            if(string_index(columns, num_columns, fields[idx]) == -1) {
                out_indexes[out_idx++] = idx;
            }
        }
        *output_indexes = out_indexes;
        return num_fields-num_columns;
    }

    return 0;
}

int bro_cut(int num_columns, char *columns[], int negate, char *ofs) {
    char line[MAX_LINE];

    int *out_indexes;
    int num_out_indexes;

    while(fgets(line, MAX_LINE , stdin) != NULL) {
        line[strlen(line)-1]='\0';
        if(strlen(line) && line[0] == '#') {
            if(strncmp(line, "#fields", 7) == 0) {
                num_out_indexes = find_output_indexes(&out_indexes, num_columns, columns, negate, line);
            }
            continue;
        }

        output_indexes(line, out_indexes, num_out_indexes, ofs);
    }
    return 0;
}

int main(int argc, char *argv[]) {
    int negate = 0;
    int c;
    char *ofs = "\t";
    while((c = getopt(argc, argv, "nF:")) != -1){
        switch(c){
            case 'n':
                negate = 1;
                break;
            case 'F':
                ofs = optarg;
                break;
        }
    }
    return bro_cut(argc-optind, &argv[optind], negate, ofs);
}
