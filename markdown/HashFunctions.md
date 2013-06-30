here's some hash functions for those who like to optimize there core foundation dictionaries. These are C versions of the C++ versions post here -> http://www.partow.net/programming/hashfunctions/

When you supply the hash hook function for General/CFDictionaryHashCallBack you have to cast the function correctly (e.g.     keyCallbacks.hash = (General/CFHashCode (*)(const void *))General/ELFHash;)

C Hash Functions:
    
unsigned int General/RSHash(char *str) {
    unsigned int a = 63689, b = 378551, hash = 0, i, length = strlen(str);
    for(i = 0; i < length; i++) {hash = hash*a+str[i]; a = a*b;}
    return (hash & 0x7FFFFFFF);
}

unsigned int General/JSHash(char *str) {
    unsigned int hash = 1315423911, i, length = strlen(str);
    for(i = 0; i < length; i++) hash ^= ((hash << 5) + str[i] + (hash >> 2));
    return (hash & 0x7FFFFFFF);
}

unsigned int General/PJWHash(char *str) {
    unsigned int i, length = strlen(str);
    unsigned int General/BitsInUnignedInt = (unsigned int)(sizeof(unsigned int) * 8);
    unsigned int General/ThreeQuarters    = (unsigned int)((General/BitsInUnignedInt  * 3) / 4);
    unsigned int General/OneEighth        = (unsigned int)(General/BitsInUnignedInt / 8);
    unsigned int General/HighBits         = (unsigned int)(0xFFFFFFFF) << (General/BitsInUnignedInt - General/OneEighth);
    unsigned int hash             = 0;
    unsigned int test             = 0;

    for(i = 0; i < length; i++) {
        hash = (hash << General/OneEighth) + str[i];
        if((test = hash & General/HighBits)  != 0) hash = (( hash ^ (test >> General/ThreeQuarters)) & (~General/HighBits));
    }
    return (hash & 0x7FFFFFFF);
}

unsigned int General/ELFHash(char *str) {
    unsigned int hash = 0, x = 0, i, length = strlen(str);
    for(i = 0; i < length; i++) {
        hash = (hash << 4) + str[i];
        if((x = hash & 0xF0000000L) != 0) {hash ^= (x >> 24); hash &= ~x;}
    }
    return (hash & 0x7FFFFFFF);
}

unsigned int General/BKDRHash(char *str) {
    unsigned int seed = 131, hash = 0, i, length = strlen(str);
    for(i = 0; i < length; i++) hash = (hash*seed)+str[i];
    return (hash & 0x7FFFFFFF);
}

unsigned int General/SDBMHash(char *str) {
    unsigned int hash = 0, i, length = strlen(str);
    for(i = 0; i < length; i++) hash = str[i] + (hash << 6) + (hash << 16) - hash;
    return (hash & 0x7FFFFFFF);
}

unsigned int General/DJBHash(char *str) {
    unsigned int hash = 5381, i, length = strlen(str);
    for(i = 0; i < length; i++) hash = ((hash << 5) + hash) + str[i];
    return (hash & 0x7FFFFFFF);
}


--zootbobbalu

----

Very nice indeed, but how and why do I use them?