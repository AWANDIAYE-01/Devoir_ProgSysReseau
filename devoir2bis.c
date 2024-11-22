#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

void creer_matrice(int **matrice, int dimension) {
    // Remplir la matrice avec des valeurs aléatoires entre 0 et 99
    for (int i = 0; i < dimension; i++) {
        for (int j = 0; j < dimension; j++) {
            matrice[i][j] = rand() % 100;
        }
    }
}

void enregistrer_matrice_texte(const char *nom_fichier, int **matrice, int dimension) {
    FILE *fichier = fopen(nom_fichier, "w");
    if (!fichier) {
        perror("Erreur d'ouverture du fichier");
        return;
    }

    // Enregistrer la matrice au format texte
    for (int i = 0; i < dimension; i++) {
        for (int j = 0; j < dimension; j++) {
            fprintf(fichier, "%d ", matrice[i][j]);
        }
        fprintf(fichier, "\n");
    }

    fclose(fichier);
    printf("Matrice enregistrée au format texte dans %s\n", nom_fichier);
}

void afficher_matrice_texte(const char *nom_fichier) {
    FILE *fichier = fopen(nom_fichier, "r");
    if (!fichier) {
        perror("Erreur d'ouverture du fichier");
        return;
    }

    int valeur;
    while (fscanf(fichier, "%d", &valeur) != EOF) {
        printf("%d ", valeur);
    }

    fclose(fichier);
    printf("\n");
}

int main(int argc, char *argv[]) {
    int dimension = 0;
    int creer = 0;
    int afficher = 0;
    int texte = 0;
    char *nom_fichier = NULL;

    // Analyser les arguments de la ligne de commande
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-c") == 0) {
            creer = 1;
        } else if (strcmp(argv[i], "-a") == 0) {
            afficher = 1;
        } else if (strcmp(argv[i], "-d") == 0) {
            if (i + 1 < argc) {
                dimension = atoi(argv[i + 1]);
                i++;
            } else {
                fprintf(stderr, "Erreur: option -d nécessite un argument.\n");
                return 1;
            }
        } else if (strcmp(argv[i], "-f") == 0) {
            if (i + 1 < argc) {
                nom_fichier = argv[i + 1];
                i++;
            } else {
                fprintf(stderr, "Erreur: option -f nécessite un nom de fichier.\n");
                return 1;
            }
        } else if (strcmp(argv[i], "-t") == 0) {
            texte = 1;
        } else if (strcmp(argv[i], "-b") == 0) {
            // Mode binaire (par défaut)
        }
    }

    if (dimension <= 0) {
        fprintf(stderr, "Erreur: la dimension de la matrice doit être spécifiée avec -d.\n");
        return 1;
    }

    if (nom_fichier == NULL) {
        fprintf(stderr, "Erreur: le nom du fichier doit être spécifié avec -f.\n");
        return 1;
    }

    // Créer la matrice aléatoire si demandé
    int **matrice = malloc(dimension * sizeof(int *));
    for (int i = 0; i < dimension; i++) {
        matrice[i] = malloc(dimension * sizeof(int));
    }

    srand(time(NULL)); // Initialiser le générateur de nombres aléatoires

    if (creer) {
        creer_matrice(matrice, dimension);

        // Enregistrer la matrice en mode texte
        if (texte) {
            enregistrer_matrice_texte(nom_fichier, matrice, dimension);
        }
    }

    // Afficher la matrice si demandé
    if (afficher) {
        afficher_matrice_texte(nom_fichier);
    }

    // Libérer la mémoire
    for (int i = 0; i < dimension; i++) {
        free(matrice[i]);
    }
    free(matrice);

    return 0;
}
