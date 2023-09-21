#include <pthread.h>
#include <stdio.h>
#include <assert.h>

pthread_mutex_t mutex;
pthread_cond_t cond;

int buffer;
long counter = 0;//protocols starts with empty buffer

void put(int value) {
    assert(counter == 0);
    counter = 1;
    buffer = value;
}

int get() {
    assert(counter == 1);
    counter = 0;
    return buffer;
}

void* produce(void *args) {
    int i;
    int items_to_produce = (int) args;
    for (i = 0; i < items_to_produce; i++) {
        pthread_mutex_lock(&mutex);
        if (counter == 1)
            pthread_cond_wait(&cond, &mutex);
        put(i);
        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&mutex)
    }
    return NULL;
}

void* consume(void *args) {
    int i;
    int items_to_consume = (int) args;
    for (i = 0; i < items_to_consume; i++) {
        pthread_mutex_lock(&mutex);
        if (counter == 0)
            pthread_cond_wait(&cond, &mutex);
        int tmp = get();
        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&mutex)
        printf("%d\n", tmp);
    }
    return NULL;
}

int main() {
    pthread_t t0;
    pthread_t t1;

    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);

    pthread_create(&t0, NULL, produce, 100000);
    pthread_create(&t1, NULL, consume, NULL);

    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
}
