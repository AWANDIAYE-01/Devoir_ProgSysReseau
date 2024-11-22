#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

void creation_matrix(const char *fichier, int dimension, int mode_binaire) {
    FILE *file = mode_binaire ? fopen(fichier, "wb") : fopen(fichier, "w");
    if (!file) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(-1);
    }

    srand(time(NULL));
    for (int i = 0; i < dimension; i++) {
        for (int j = 0; j < dimension; j++) {
            int value = rand() % 100; // Génère des nombres aléatoires entre 0 et 99
            if (mode_binaire) {
                fwrite(&value, sizeof(int), 1, file);
            } else {
                fprintf(file, "%d ", value);
            }
        }
        if (!mode_binaire) {
            fprintf(file, "\n");
        }
    }
    fclose(file);
    printf("Matrice créée et enregistrée dans '%s'\n", fichier);
}

void display_matrix(const char *fichier, int dimension, int mode_binaire) {
    FILE *file = fopen(fichier, mode_binaire ? "rb" : "r");
    if (!file) {
        perror("Erreur lors de l'ouverture du fichier");
        exit(-1);
    }

    printf("Contenu du fichier '%s':\n", fichier);
    for (int i = 0; i < dimension; i++) {
        for (int j = 0; j < dimension; j++) {
            int value;
            if (mode_binaire) {
                fread(&value, sizeof(int), 1, file);
                printf("%d ", value);
            } else {
                fscanf(file, "%d", &value);
                printf("%d ", value);
            }
        }
        printf("\n");
    }
    fclose(file);
}

int main(int argc, char *argv[]) {
    int create_flag = 0, display_flag = 0, mode_binaire = 1, dimension = 0;
    char *fichier = NULL;
    int opt;

    while ((opt = getopt(argc, argv, "cad:f:bt")) != -1) {
        switch (opt) {
            case 'c':
                create_flag = 1;
                break;
            case 'a':
                display_flag = 1;
                break;
            case 'd':
                dimension = atoi(optarg);
                break;
            case 'f':
                fichier = optarg;
                break;
            case 'b':
                mode_binaire = 1;
                break;
            case 't':
                mode_binaire = 0;
                break;
            default:
                fprintf(stderr, "Usage: %s [-c] [-a] [-d dimension] [-f filename] [-b|-t]\n", argv[0]);
                exit(-1);
        }
    }

    if (!fichier || dimension <= 0) {
        fprintf(stderr, "Veuillez spécifier un fichier (-f) et une dimension valide (-d).\n");
        exit(-1);
    }

    if (create_flag) {
        creation_matrix(fichier, dimension, mode_binaire);
    } else if (display_flag) {
        display_matrix(fichier, dimension, mode_binaire);
    } else {
        fprintf(stderr, "Veuillez spécifier une action (-c ou -a).\n");
        exit(-1);
    }

    return 0;
}
