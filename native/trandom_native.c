// This native library is needed and works only in Windows for accessing
// the RtlGenRandom system call.
// CPP, Neko, and Hashlink targets are supported.
#include <stdint.h>
#include <stdbool.h>
#include <windows.h>

typedef bool (__stdcall *RtlGenRandom)(void*, unsigned long int);

#ifdef LIBHL_EXPORTS
    #include <hl.h>
    #define FUNC HL_PRIM
    #define FUNC_NAME(name) hl_##name
#elif NEKOVM_DLL_EXPORTS
    #include <neko.h>
    #define FUNC
    #define FUNC_NAME(name) name
#else
    #define FUNC
    #define FUNC_NAME(name) name
#endif

FUNC int FUNC_NAME(trandom_get)(int32_t* output) {
    static bool loaded = false;
    static HMODULE module;
    static RtlGenRandom func;

    if (!loaded) {
        module = LoadLibrary("advapi32.dll");

        if (module == NULL) {
            return -1;
        }

        func = (RtlGenRandom) GetProcAddress(module, "SystemFunction036");

        if (func == NULL) {
            return -1;
        }

        loaded = true;
    }

    uint8_t buffer[4] =
#if __cplusplus__
        {};
#else
        {0};
#endif
    int success = func(buffer, 4);

    if (!success) {
        return -1;
    }

    *output = (buffer[0] << 24) |
        (buffer[1] << 16) |
        (buffer[2] << 8) |
        buffer[3];

    return 0;
}

#ifdef LIBHL_EXPORTS

DEFINE_PRIM(_I32, trandom_get, _REF(_I32) );

int trandom_trandom_get(int32_t* output) {
    return FUNC_NAME(trandom_get)(output);
}

#elif NEKOVM_DLL_EXPORTS

value trandom_get_neko() {
    int32_t random_value = 0;
    int error = trandom_get(&random_value);

    if (error) {
        failure("Random source not available");
    } else {
        return alloc_int32(random_value);
    }
}

DEFINE_PRIM(trandom_get_neko, 0);

#endif
