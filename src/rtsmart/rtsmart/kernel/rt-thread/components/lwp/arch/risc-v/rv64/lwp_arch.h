/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 */

#ifndef  LWP_ARCH_H__
#define  LWP_ARCH_H__

#include <lwp.h>
#include <lwp_arch_comm.h>
#include <riscv_mmu.h>

#ifdef RT_USING_USERSPACE

#ifdef RT_USING_USERSPACE_32BIT_LIMIT
#define USER_HEAP_VADDR     0xF0000000UL
#define USER_HEAP_VEND      0xFE000000UL
#define USER_STACK_VSTART   0xE0000000UL
#define USER_STACK_VEND     USER_HEAP_VADDR
#define USER_VADDR_START    0xC0000000UL
#define USER_VADDR_TOP      0xFF000000UL
#define USER_LOAD_VADDR     0xD0000000UL
#define LDSO_LOAD_VADDR     USER_LOAD_VADDR
#else
#define USER_HEAP_VADDR     0x300000000UL
#define USER_HEAP_VEND      0xffffffffffff0000UL
#define USER_STACK_VSTART   0x270000000UL
#define USER_STACK_VEND     USER_HEAP_VADDR
#define USER_VADDR_START    0x100000000UL
#define USER_VADDR_TOP      0xfffffffffffff000UL
#define USER_LOAD_VADDR     0x200000000
#define LDSO_LOAD_VADDR     0x200000000
#endif

rt_inline rt_bool_t lwp_in_user_space(const char *addr)
{
    return (addr >= (char *)USER_VADDR_START && addr < (char *)USER_VADDR_TOP);
}

/* Pangofly shared memory reserved region */
/* 
 * Memory layout analysis (RISC-V 64-bit mode):
 * 
 * USER_VADDR_START (0x100000000) = 4GB
 * USER_LOAD_VADDR  (0x200000000) = 8GB  - ELF programs loaded here
 * USER_STACK_VSTART(0x270000000) = 9.75GB - Stack starts here
 * USER_STACK_VEND  (0x300000000) = 12GB  - Stack ends, heap starts
 * USER_HEAP_VADDR  (0x300000000) = 12GB  - Heap starts here
 * USER_HEAP_VEND   (0xffffffffffff0000)  - Heap ends
 * USER_VADDR_TOP   (0xfffffffffffff000)  - User space top
 * 
 * Best reserved region: Between USER_VADDR_START and USER_LOAD_VADDR
 * This area (4GB - 8GB) is not used by ELF loading, stack, or heap
 * and provides up to 4GB of contiguous address space.
 */
#ifdef LWP_PANGOFLY_RESERVE_ENABLE
#ifndef PANGOFLY_RESERVE_ADDR
#define PANGOFLY_RESERVE_ADDR   0x120000000UL  /* 4.5GB, after USER_VADDR_START */
#endif
#ifndef PANGOFLY_RESERVE_SIZE
#define PANGOFLY_RESERVE_SIZE   0x80000000UL  /* 256MB - large enough for multiple channels */
#endif
#define PANGOFLY_RESERVE_END    (PANGOFLY_RESERVE_ADDR + PANGOFLY_RESERVE_SIZE)

rt_inline rt_bool_t lwp_is_in_pangofly_reserve(const char *addr)
{
    return (addr >= (char *)PANGOFLY_RESERVE_ADDR && addr < (char *)PANGOFLY_RESERVE_END);
}
#endif

/* this attribution is cpu specified, and it should be defined in riscv_mmu.h */
#ifndef MMU_MAP_U_RWCB
#define MMU_MAP_U_RWCB 0
#endif

#ifndef MMU_MAP_U_RW
#define MMU_MAP_U_RW 0
#endif

#ifdef __cplusplus
extern "C" {
#endif

rt_mmu_info* arch_kernel_get_mmu_info(void);

rt_inline unsigned long rt_hw_ffz(unsigned long x)
{
    return __builtin_ffsl(~x) - 1;
}

rt_inline void icache_invalid_all(void)
{
    //TODO:
}

#ifdef __cplusplus
}
#endif

#endif

#endif  /*LWP_ARCH_H__*/
