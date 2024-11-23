#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

// Variables globales
int nombre_threads;            // Nombre total de threads
sem_t* semaphores;             // Tableau de sémaphores pour synchroniser les threads

// Fonction exécutée par chaque thread
void* fonction_thread(void* arg) {
    int id = (int)arg;  // Identifiant du thread

    while (1) {
        sem_wait(&semaphores[id]); // Attendre son tour
        printf("Thread %d : Je viens de m'exécuter.\n", id + 1);
        sem_post(&semaphores[(id + 1) % nombre_threads]); // Réveiller le prochain thread
    }
    pthread_exit(NULL);
}

int main() {
    printf("Entrez le nombre de threads : ");
    scanf("%d", &nombre_threads);

    // Allocation des threads et des sémaphores
    pthread_t threads[nombre_threads];
    semaphores = malloc(nombre_threads * sizeof(sem_t));
    int identifiants[nombre_threads];

    // Initialisation des sémaphores
    for (int i = 0; i < nombre_threads; i++) {
        sem_init(&semaphores[i], 0, (i == 0) ? 1 : 0); // Le premier thread démarre
        identifiants[i] = i;
    }

    // Création des threads
    for (int i = 0; i < nombre_threads; i++) {
        pthread_create(&threads[i], NULL, fonction_thread, &identifiants[i]);
    }

    // Attendre la fin des threads (théoriquement, jamais atteint ici)
    for (int i = 0; i < nombre_threads; i++) {
        pthread_join(threads[i], NULL);
    }

    // Destruction des sémaphores
    for (int i = 0; i < nombre_threads; i++) {
        sem_destroy(&semaphores[i]);
    }
    free(semaphores);

    printf("Programme terminé.\n");
    return 0;
}