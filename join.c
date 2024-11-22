#include <stdio.h>
#include <stdlib.h>

void rejoindre_fichiers(int nombre_parties, char *nom_fichier_sortie, char **fichiers_parts) {
    FILE *fichier_sortie = fopen(nom_fichier_sortie, "wb");
    if (!fichier_sortie) {
        perror("Erreur d'ouverture du fichier de sortie");
        return;
    }

    for (int i = 0; i < nombre_parties; i++) {
        FILE *fichier_partie = fopen(fichiers_parts[i], "rb");
        if (!fichier_partie) {
            perror("Erreur d'ouverture du fichier partie");
            fclose(fichier_sortie);
            return;
        }

        unsigned char tampon[1024];
        size_t bytes_lus;
        while ((bytes_lus = fread(tampon, 1, sizeof(tampon), fichier_partie)) > 0) {
            fwrite(tampon, 1, bytes_lus, fichier_sortie);
        }

        fclose(fichier_partie);
    }

    fclose(fichier_sortie);
    printf("Fichiers joints dans %s\n", nom_fichier_sortie);
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Utilisation: %s <nom_fichier_sortie> <partie1> <partie2> ... <partieN>\n", argv[0]);
        return 1;
    }

    const char *nom_fichier_sortie = argv[1];
    int nombre_parties = argc - 2;
    char **fichiers_parts = &argv[2];

    rejoindre_fichiers(nombre_parties, nom_fichier_sortie, fichiers_parts);
    return 0;
}
