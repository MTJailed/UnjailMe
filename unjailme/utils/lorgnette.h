//
//  lorgnette.h
//  liblorgnette
//
//  Created by Dmitry Rodionov on 9/24/14.
//  Copyright (c) 2014 rodionovd. All rights reserved.
//
#include <mach/mach.h>
#define CALLSYMBOL(function, ...) function(__VA_ARGS__)
#define LC_SEGMENT_NATIVE LC_SEGMENT
#define segment_command_native segment_command
#define section_native section
#pragma once
/**
 * @abstract
 * Locate a symbol inside an arbitrary process' address space.
 *
 * @note
 * This function iterates local symbols first and only then it looks for symbols
 * in linked libraries.
 *
 * @param target
 * The target process to inspect.
 * @param symbol_name
 * The name of the symbol to find. This parameter must not be NULL.
 *
 * @return
 * An address of the given symbol within the given process, or 0 (zero) if this symbol
 * could not be found.
 *
 * @b Examples
 *
 * Find a @p dlopen symbol address within the current task memory space
 * @code
 * addr = lorgnette_lookup(mach_task_self(), "dlopen");
 * @endcode
 * Find a @p glob_var0 symbol address inside a remote process
 * @code
 * addr = lorgnette_lookup(some_task, "glob_var0");
 * @endcode
 */
mach_vm_address_t lorgnette_lookup(task_t target, const char *symbol_name);

/**
 * @abstract
 * Locate a symbol within a particular image inside an alien process.
 *
 * @param target
 * The target process to inspect.
 * @param symbol_name
 * The name of the symbol to find. This parameter must not be NULL.
 * @param image_name
 * The name of the host image of the given symbol. This may be NULL.
 * The image name should be either a full file path or just a file base name.
 *
 * @return
 * An address of the given symbol within the given process, or 0 (zero) if this symbol
 * could not be found [within the given image, if @p image_name is not NULL].
 *
 * @see lorgnette_lookup()
 */
mach_vm_address_t lorgnette_lookup_image(task_t target, const char *symbol_name, const char *image_name);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
typedef void* (*arbitrary_command)();
#pragma clang diagnostic push

addr64_t lorgnette_lookup_baseaddress(const char* library_name);
arbitrary_command arbitrary(char* symbolname);
arbitrary_command arbitrary_fromlib(char* symbolname, char* lib);
