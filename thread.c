#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

// Déclaration des sémaphores
sem_t semaphore1, semaphore2;
int valeur = 0;  // La valeur partagée
int n;           // Limite supérieure/inférieure

// Fonction pour le thread 1 (+1)
void* thread1_fonction(void* arg) {
    for (int i = 1; i <= n; i++) {
        sem_wait(&semaphore1); // Attendre que le sémaphore 1 soit disponible
        valeur++;
        printf("Thread 1: %d\n", valeur);
        sem_post(&semaphore2); // Libérer le sémaphore 2
    }
    pthread_exit(NULL);
}

// Fonction pour le thread 2 (-1)
void* thread2_fonction(void* arg) {
    for (int i = 1; i <= n; i++) {
        sem_wait(&semaphore2); // Attendre que le sémaphore 2 soit disponible
        valeur--;
        printf("Thread 2: %d\n", valeur);
        sem_post(&semaphore1); // Libérer le sémaphore 1
    }
    pthread_exit(NULL);
}

int main() {
    pthread_t thread1, thread2;

    // Demander à l'utilisateur la valeur de n
    printf("Entrez la valeur de n : ");
    scanf("%d", &n);

    // Initialisation des sémaphores
    sem_init(&semaphore1, 0, 1); // Le thread 1 commence
    sem_init(&semaphore2, 0, 0);

    // Création des threads
    pthread_create(&thread1, NULL, thread1_fonction, NULL);
    pthread_create(&thread2, NULL, thread2_fonction, NULL);

    // Attendre la fin des threads
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    // Destruction des sémaphores
    sem_destroy(&semaphore1);
    sem_destroy(&semaphore2);

    printf("Programme terminé.\n");
    return 0;
}
