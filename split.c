#include <stdio.h>
#include <stdlib.h>

void diviser_fichier(FILE *fichier_entr, const char *nom_fichier, size_t taille_partie) {
    char nom_partie[256];
    int numero_partie = 1;
    size_t bytes_lus;
    unsigned char *tampon = malloc(taille_partie);

    if (!tampon) {
        perror("Erreur d'allocation mémoire");
        return;
    }

    while ((bytes_lus = fread(tampon, 1, taille_partie, fichier_entr)) > 0) {
        // Création du nom pour chaque fichier partie
        snprintf(nom_partie, sizeof(nom_partie), "%s.part%d", nom_fichier, numero_partie);
        FILE *fichier_sortie = fopen(nom_partie, "wb");
        if (!fichier_sortie) {
            perror("Erreur d'ouverture du fichier de sortie");
            free(tampon);
            return;
        }

        // Écriture du contenu dans le fichier partie
        fwrite(tampon, 1, bytes_lus, fichier_sortie);
        fclose(fichier_sortie);
        numero_partie++;
    }

    free(tampon);
    printf("Fichier divisé en %d parties.\n", numero_partie - 1);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Utilisation: %s <nom_fichier> <taille_partie_en_octets>\n", argv[0]);
        return 1;
    }

    const char *nom_fichier = argv[1];
    size_t taille_partie = atoi(argv[2]);

    FILE *fichier_entr = fopen(nom_fichier, "rb");
    if (!fichier_entr) {
        perror("Erreur d'ouverture du fichier d'entrée");
        return 1;
    }

    diviser_fichier(fichier_entr, nom_fichier, taille_partie);
    fclose(fichier_entr);

    return 0;
}
