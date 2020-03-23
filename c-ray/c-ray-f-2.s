	.text
	.intel_syntax noprefix
	.file	"c-ray-f-2.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI0_0:
	.quad	4746794007244308480     # double 2147483647
.LCPI0_1:
	.quad	-4620693217682128896    # double -0.5
.LCPI0_2:
	.quad	4652218415073722368     # double 1024
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	push	rax
	.cfi_def_cfa_offset 64
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	edi, offset .L.str.1
	mov	esi, offset .L.str.2
	call	fopen
	mov	r14, rax
	mov	edi, offset .L.str.3
	mov	esi, offset .L.str.4
	call	fopen
	mov	r13, rax
	movsxd	rax, dword ptr [rip + xres]
	movsxd	rdi, dword ptr [rip + yres]
	imul	rdi, rax
	shl	rdi, 2
	call	malloc
	test	rax, rax
	je	.LBB0_1
# %bb.2:
	mov	r15, rax
	mov	rdi, r14
	call	load_scene
	mov	rbp, -24576
	.p2align	4, 0x90
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	call	rand
	vmovsd	xmm0, qword ptr [rip + .LCPI0_0] # xmm0 = mem[0],zero
	vmovapd	xmm1, xmm0
	vcvtsi2sd	xmm0, xmm2, eax
	vdivsd	xmm0, xmm0, xmm1
	vmovsd	xmm1, qword ptr [rip + .LCPI0_1] # xmm1 = mem[0],zero
	vaddsd	xmm0, xmm0, xmm1
	vmovsd	qword ptr [rbp + urand+24576], xmm0
	add	rbp, 24
	jne	.LBB0_3
# %bb.4:
	mov	rbp, -24576
	.p2align	4, 0x90
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
	call	rand
	vcvtsi2sd	xmm0, xmm2, eax
	vdivsd	xmm0, xmm0, qword ptr [rip + .LCPI0_0]
	vaddsd	xmm0, xmm0, qword ptr [rip + .LCPI0_1]
	vmovsd	qword ptr [rbp + urand+24584], xmm0
	add	rbp, 24
	jne	.LBB0_5
# %bb.6:
	mov	rbp, -4096
	.p2align	4, 0x90
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	call	rand
	vcvtsi2sd	xmm0, xmm2, eax
	vdivsd	xmm0, xmm0, qword ptr [rip + .LCPI0_0]
	vmulsd	xmm0, xmm0, qword ptr [rip + .LCPI0_2]
	vcvttsd2si	eax, xmm0
	mov	dword ptr [rbp + irand+4096], eax
	add	rbp, 4
	jne	.LBB0_7
# %bb.8:
	mov	edi, offset get_msec.timeval
	xor	esi, esi
	call	gettimeofday
	mov	rax, qword ptr [rip + get_msec.first_timeval]
	test	rax, rax
	jne	.LBB0_10
# %bb.9:
	vmovupd	xmm0, xmmword ptr [rip + get_msec.timeval]
	vmovupd	xmmword ptr [rip + get_msec.first_timeval], xmm0
	xor	r12d, r12d
	jmp	.LBB0_11
.LBB0_10:
	mov	rcx, qword ptr [rip + get_msec.timeval]
	sub	rcx, rax
	imul	rcx, rcx, 1000
	mov	rax, qword ptr [rip + get_msec.timeval+8]
	sub	rax, qword ptr [rip + get_msec.first_timeval+8]
	movabs	rdx, 2361183241434822607
	imul	rdx
	mov	r12, rdx
	mov	rax, rdx
	shr	rax, 63
	sar	r12, 7
	add	r12, rax
	add	r12, rcx
.LBB0_11:
	mov	edi, dword ptr [rip + xres]
	mov	esi, dword ptr [rip + yres]
	mov	rdx, r15
	mov	ecx, 1
	call	render
	mov	edi, offset get_msec.timeval
	xor	esi, esi
	call	gettimeofday
	mov	rax, qword ptr [rip + get_msec.first_timeval]
	test	rax, rax
	jne	.LBB0_13
# %bb.12:
	vmovupd	xmm0, xmmword ptr [rip + get_msec.timeval]
	vmovupd	xmmword ptr [rip + get_msec.first_timeval], xmm0
	xor	ecx, ecx
	jmp	.LBB0_14
.LBB0_13:
	mov	rcx, qword ptr [rip + get_msec.timeval]
	sub	rcx, rax
	imul	rsi, rcx, 1000
	mov	rax, qword ptr [rip + get_msec.timeval+8]
	sub	rax, qword ptr [rip + get_msec.first_timeval+8]
	movabs	rcx, 2361183241434822607
	imul	rcx
	mov	rcx, rdx
	mov	rax, rdx
	shr	rax, 63
	sar	rcx, 7
	add	rcx, rax
	add	rcx, rsi
.LBB0_14:
	sub	rcx, r12
	mov	rdi, qword ptr [rip + stderr]
	mov	rdx, rcx
	shr	rdx, 3
	movabs	rax, 2361183241434822607
	mulx	rdx, rax, rax
	shr	rdx, 4
	mov	esi, offset .L.str.6
	xor	eax, eax
	call	fprintf
	mov	edx, dword ptr [rip + xres]
	mov	ecx, dword ptr [rip + yres]
	mov	rdi, r13
	mov	esi, offset .L.str.7
	xor	eax, eax
	call	fprintf
	mov	eax, dword ptr [rip + yres]
	imul	eax, dword ptr [rip + xres]
	test	eax, eax
	jle	.LBB0_17
# %bb.15:
	xor	ebp, ebp
	mov	r12d, 2064
	.p2align	4, 0x90
.LBB0_16:                               # =>This Inner Loop Header: Depth=1
	mov	ebx, dword ptr [r15 + 4*rbp]
	bextr	edi, ebx, r12d
	mov	rsi, r13
	call	fputc_unlocked
	movzx	edi, bh
	mov	rsi, r13
	call	fputc_unlocked
	movzx	edi, bl
	mov	rsi, r13
	call	fputc_unlocked
	add	rbp, 1
	movsxd	rax, dword ptr [rip + xres]
	movsxd	rcx, dword ptr [rip + yres]
	imul	rcx, rax
	cmp	rbp, rcx
	jl	.LBB0_16
.LBB0_17:
	mov	rdi, r13
	call	fflush
	cmp	r14, qword ptr [rip + stdin]
	je	.LBB0_19
# %bb.18:
	mov	rdi, r14
	call	fclose
.LBB0_19:
	xor	ebp, ebp
	cmp	r13, qword ptr [rip + stdout]
	je	.LBB0_21
# %bb.20:
	mov	rdi, r13
	call	fclose
.LBB0_21:
	mov	eax, ebp
	add	rsp, 8
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.LBB0_1:
	.cfi_def_cfa_offset 64
	mov	edi, offset .L.str.5
	call	perror
	mov	ebp, 1
	jmp	.LBB0_21
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	load_scene              # -- Begin function load_scene
	.p2align	4, 0x90
	.type	load_scene,@function
load_scene:                             # @load_scene
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r14
	.cfi_def_cfa_offset 24
	push	rbx
	.cfi_def_cfa_offset 32
	sub	rsp, 336
	.cfi_def_cfa_offset 368
	.cfi_offset rbx, -32
	.cfi_offset r14, -24
	.cfi_offset rbp, -16
	mov	rbx, rdi
	mov	edi, 80
	call	malloc
	mov	qword ptr [rip + obj_list], rax
	mov	qword ptr [rax + 72], 0
	lea	rdi, [rsp + 80]
	mov	esi, 256
	mov	rdx, rbx
	call	fgets
	test	rax, rax
	je	.LBB1_21
# %bb.1:
	lea	r14, [rsp + 80]
	jmp	.LBB1_2
	.p2align	4, 0x90
.LBB1_4:                                #   in Loop: Header=BB1_2 Depth=1
	add	rax, 1
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	movzx	ecx, byte ptr [rax]
	add	cl, -9
	cmp	cl, 26
	ja	.LBB1_5
# %bb.3:                                #   in Loop: Header=BB1_2 Depth=1
	movzx	ecx, cl
	jmp	qword ptr [8*rcx + .LJTI1_0]
.LBB1_20:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, r14
	mov	esi, 256
	mov	rdx, rbx
	call	fgets
	test	rax, rax
	jne	.LBB1_2
	jmp	.LBB1_21
.LBB1_5:                                #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, r14
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_20
# %bb.6:                                #   in Loop: Header=BB1_2 Depth=1
	movsx	ebp, byte ptr [rax]
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_8
# %bb.7:                                #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 16], xmm0
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_8
# %bb.22:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 24], xmm0
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_8
# %bb.23:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 32], xmm0
.LBB1_8:                                #   in Loop: Header=BB1_2 Depth=1
	cmp	bpl, 108
	jne	.LBB1_10
# %bb.9:                                #   in Loop: Header=BB1_2 Depth=1
	movsxd	rax, dword ptr [rip + lnum]
	lea	ecx, [rax + 1]
	mov	dword ptr [rip + lnum], ecx
	shl	rax, 3
	mov	rcx, qword ptr [rsp + 32]
	mov	qword ptr [rax + 2*rax + lights+16], rcx
	vmovups	xmm0, xmmword ptr [rsp + 16]
	vmovups	xmmword ptr [rax + 2*rax + lights], xmm0
	jmp	.LBB1_20
.LBB1_10:                               #   in Loop: Header=BB1_2 Depth=1
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_20
# %bb.11:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 8], xmm0 # 8-byte Spill
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_13
# %bb.12:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 40], xmm0
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_13
# %bb.24:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 48], xmm0
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_13
# %bb.25:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 56], xmm0
.LBB1_13:                               #   in Loop: Header=BB1_2 Depth=1
	cmp	bpl, 99
	jne	.LBB1_15
# %bb.14:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rax, qword ptr [rsp + 32]
	mov	qword ptr [rip + cam+16], rax
	vmovups	xmm0, xmmword ptr [rsp + 16]
	vmovups	xmmword ptr [rip + cam], xmm0
	vmovups	xmm0, xmmword ptr [rsp + 40]
	vmovups	xmmword ptr [rip + cam+24], xmm0
	mov	rax, qword ptr [rsp + 56]
	mov	qword ptr [rip + cam+40], rax
	vmovsd	xmm0, qword ptr [rsp + 8] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	qword ptr [rip + cam+48], xmm0
	jmp	.LBB1_20
.LBB1_15:                               #   in Loop: Header=BB1_2 Depth=1
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_20
# %bb.16:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 72], xmm0 # 8-byte Spill
	xor	edi, edi
	mov	esi, offset .L.str.8
	call	strtok
	test	rax, rax
	je	.LBB1_20
# %bb.17:                               #   in Loop: Header=BB1_2 Depth=1
	cmp	bpl, 115
	jne	.LBB1_19
# %bb.18:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, rax
	xor	esi, esi
	call	strtod
	vmovsd	qword ptr [rsp + 64], xmm0 # 8-byte Spill
	mov	edi, 80
	call	malloc
	mov	rcx, qword ptr [rip + obj_list]
	mov	rdx, qword ptr [rcx + 72]
	mov	qword ptr [rax + 72], rdx
	mov	qword ptr [rcx + 72], rax
	mov	rcx, qword ptr [rsp + 32]
	mov	qword ptr [rax + 16], rcx
	vmovups	xmm0, xmmword ptr [rsp + 16]
	vmovups	xmmword ptr [rax], xmm0
	vmovsd	xmm0, qword ptr [rsp + 8] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	qword ptr [rax + 24], xmm0
	vmovups	xmm0, xmmword ptr [rsp + 40]
	vmovups	xmmword ptr [rax + 32], xmm0
	mov	rcx, qword ptr [rsp + 56]
	mov	qword ptr [rax + 48], rcx
	vmovsd	xmm0, qword ptr [rsp + 72] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	qword ptr [rax + 56], xmm0
	vmovsd	xmm0, qword ptr [rsp + 64] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	qword ptr [rax + 64], xmm0
	jmp	.LBB1_20
.LBB1_19:                               #   in Loop: Header=BB1_2 Depth=1
	mov	rdi, qword ptr [rip + stderr]
	mov	esi, offset .L.str.9
	mov	edx, ebp
	xor	eax, eax
	call	fprintf
	jmp	.LBB1_20
.LBB1_21:
	add	rsp, 336
	.cfi_def_cfa_offset 32
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end1:
	.size	load_scene, .Lfunc_end1-load_scene
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
.LJTI1_0:
	.quad	.LBB1_4
	.quad	.LBB1_20
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_4
	.quad	.LBB1_5
	.quad	.LBB1_5
	.quad	.LBB1_20
                                        # -- End function
	.text
	.globl	get_msec                # -- Begin function get_msec
	.p2align	4, 0x90
	.type	get_msec,@function
get_msec:                               # @get_msec
	.cfi_startproc
# %bb.0:
	push	rax
	.cfi_def_cfa_offset 16
	mov	edi, offset get_msec.timeval
	xor	esi, esi
	call	gettimeofday
	mov	rax, qword ptr [rip + get_msec.first_timeval]
	test	rax, rax
	je	.LBB2_1
# %bb.2:
	mov	rcx, qword ptr [rip + get_msec.timeval]
	sub	rcx, rax
	imul	rcx, rcx, 1000
	mov	rax, qword ptr [rip + get_msec.timeval+8]
	sub	rax, qword ptr [rip + get_msec.first_timeval+8]
	movabs	rdx, 2361183241434822607
	imul	rdx
	mov	rax, rdx
	shr	rdx, 63
	sar	rax, 7
	add	rax, rdx
	add	rax, rcx
	pop	rcx
	.cfi_def_cfa_offset 8
	ret
.LBB2_1:
	.cfi_def_cfa_offset 16
	vmovups	xmm0, xmmword ptr [rip + get_msec.timeval]
	vmovups	xmmword ptr [rip + get_msec.first_timeval], xmm0
	xor	eax, eax
	pop	rcx
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end2:
	.size	get_msec, .Lfunc_end2-get_msec
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function render
.LCPI3_0:
	.quad	4607182418800017408     # double 1
.LCPI3_1:
	.quad	4643176031446892544     # double 255
	.text
	.globl	render
	.p2align	4, 0x90
	.type	render,@function
render:                                 # @render
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	sub	rsp, 424
	.cfi_def_cfa_offset 480
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	dword ptr [rsp + 52], ecx # 4-byte Spill
	mov	qword ptr [rsp + 56], rdx # 8-byte Spill
                                        # kill: def $edi killed $edi def $rdi
	mov	qword ptr [rsp + 64], rdi # 8-byte Spill
	mov	dword ptr [rsp + 76], esi # 4-byte Spill
	test	esi, esi
	jle	.LBB3_21
# %bb.1:
	mov	eax, dword ptr [rsp + 52] # 4-byte Reload
	vcvtsi2sd	xmm0, xmm0, eax
	vmovsd	xmm1, qword ptr [rip + .LCPI3_0] # xmm1 = mem[0],zero
	vdivsd	xmm0, xmm1, xmm0
	vmovsd	qword ptr [rsp + 96], xmm0 # 8-byte Spill
	mov	rax, qword ptr [rsp + 64] # 8-byte Reload
	lea	eax, [rax - 1]
	add	rax, 1
	mov	qword ptr [rsp + 88], rax # 8-byte Spill
	xor	ebp, ebp
	lea	r15, [rsp + 344]
	.p2align	4, 0x90
.LBB3_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_4 Depth 2
                                        #       Child Loop BB3_7 Depth 3
                                        #         Child Loop BB3_9 Depth 4
	cmp	dword ptr [rsp + 64], 0 # 4-byte Folded Reload
	jle	.LBB3_20
# %bb.3:                                #   in Loop: Header=BB3_2 Depth=1
	xor	r14d, r14d
	mov	rax, qword ptr [rsp + 56] # 8-byte Reload
	.p2align	4, 0x90
.LBB3_4:                                #   Parent Loop BB3_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_7 Depth 3
                                        #         Child Loop BB3_9 Depth 4
	cmp	dword ptr [rsp + 52], 0 # 4-byte Folded Reload
	mov	qword ptr [rsp + 104], rax # 8-byte Spill
	vxorpd	xmm3, xmm3, xmm3
	jle	.LBB3_5
# %bb.6:                                #   in Loop: Header=BB3_4 Depth=2
	xor	r12d, r12d
	vxorpd	xmm4, xmm4, xmm4
	.p2align	4, 0x90
.LBB3_7:                                #   Parent Loop BB3_2 Depth=1
                                        #     Parent Loop BB3_4 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_9 Depth 4
	vmovsd	qword ptr [rsp + 80], xmm4 # 8-byte Spill
	vmovapd	xmmword ptr [rsp + 144], xmm3 # 16-byte Spill
	lea	rdi, [rsp + 296]
	mov	esi, r14d
	mov	edx, ebp
	mov	ecx, r12d
	vzeroupper
	call	get_primary_ray
	vmovupd	ymm0, ymmword ptr [rsp + 296]
	vmovupd	ymm1, ymmword ptr [rsp + 312]
	vmovupd	ymmword ptr [rsp + 176], ymm1
	vmovupd	ymmword ptr [rsp + 160], ymm0
	mov	rax, qword ptr [rip + obj_list]
	mov	r13, qword ptr [rax + 72]
	test	r13, r13
	je	.LBB3_16
# %bb.8:                                #   in Loop: Header=BB3_7 Depth=3
	xor	ebx, ebx
	.p2align	4, 0x90
.LBB3_9:                                #   Parent Loop BB3_2 Depth=1
                                        #     Parent Loop BB3_4 Depth=2
                                        #       Parent Loop BB3_7 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovupd	ymm0, ymmword ptr [rsp + 160]
	vmovupd	ymm1, ymmword ptr [rsp + 176]
	vmovupd	ymmword ptr [rsp + 16], ymm1
	vmovupd	ymmword ptr [rsp], ymm0
	mov	rdi, r13
	mov	rsi, r15
	vzeroupper
	call	ray_sphere
	test	eax, eax
	je	.LBB3_13
# %bb.10:                               #   in Loop: Header=BB3_9 Depth=4
	test	rbx, rbx
	je	.LBB3_12
# %bb.11:                               #   in Loop: Header=BB3_9 Depth=4
	vmovsd	xmm0, qword ptr [rsp + 280] # xmm0 = mem[0],zero
	vucomisd	xmm0, qword ptr [rsp + 416]
	jbe	.LBB3_13
.LBB3_12:                               #   in Loop: Header=BB3_9 Depth=4
	vmovupd	ymm0, ymmword ptr [rsp + 344]
	vmovupd	ymm1, ymmword ptr [rsp + 376]
	vmovupd	ymm2, ymmword ptr [rsp + 392]
	vmovupd	ymmword ptr [rsp + 256], ymm2
	vmovupd	ymmword ptr [rsp + 240], ymm1
	vmovupd	ymmword ptr [rsp + 208], ymm0
	mov	rbx, r13
.LBB3_13:                               #   in Loop: Header=BB3_9 Depth=4
	mov	r13, qword ptr [r13 + 72]
	test	r13, r13
	jne	.LBB3_9
# %bb.14:                               #   in Loop: Header=BB3_7 Depth=3
	test	rbx, rbx
	je	.LBB3_16
# %bb.15:                               #   in Loop: Header=BB3_7 Depth=3
	lea	rdi, [rsp + 112]
	mov	rsi, rbx
	lea	rdx, [rsp + 208]
	xor	ecx, ecx
	vzeroupper
	call	shade
	vmovapd	xmm0, xmmword ptr [rsp + 112]
	vmovsd	xmm1, qword ptr [rsp + 128] # xmm1 = mem[0],zero
	jmp	.LBB3_17
	.p2align	4, 0x90
.LBB3_16:                               #   in Loop: Header=BB3_7 Depth=3
	vxorpd	xmm0, xmm0, xmm0
	vmovapd	xmmword ptr [rsp + 112], xmm0
	mov	qword ptr [rsp + 128], 0
	vxorpd	xmm1, xmm1, xmm1
.LBB3_17:                               #   in Loop: Header=BB3_7 Depth=3
	vmovapd	xmm3, xmmword ptr [rsp + 144] # 16-byte Reload
	vmovsd	xmm4, qword ptr [rsp + 80] # 8-byte Reload
                                        # xmm4 = mem[0],zero
	vaddsd	xmm4, xmm4, xmm1
	vaddpd	xmm3, xmm3, xmm0
	add	r12d, 1
	cmp	r12d, dword ptr [rsp + 52] # 4-byte Folded Reload
	jne	.LBB3_7
	jmp	.LBB3_18
	.p2align	4, 0x90
.LBB3_5:                                #   in Loop: Header=BB3_4 Depth=2
	vxorpd	xmm4, xmm4, xmm4
.LBB3_18:                               #   in Loop: Header=BB3_4 Depth=2
	vmovsd	xmm2, qword ptr [rsp + 96] # 8-byte Reload
                                        # xmm2 = mem[0],zero
	vmulsd	xmm0, xmm2, xmm3
	vpermilpd	xmm1, xmm3, 1   # xmm1 = xmm3[1,0]
	vmulsd	xmm1, xmm2, xmm1
	vmulsd	xmm2, xmm2, xmm4
	vmovsd	xmm3, qword ptr [rip + .LCPI3_0] # xmm3 = mem[0],zero
	vminsd	xmm0, xmm0, xmm3
	vmovsd	xmm4, qword ptr [rip + .LCPI3_1] # xmm4 = mem[0],zero
	vmulsd	xmm0, xmm0, xmm4
	vcvttsd2si	rax, xmm0
	shl	eax, 16
	and	eax, 16711680
	vminsd	xmm0, xmm1, xmm3
	vmulsd	xmm0, xmm0, xmm4
	vcvttsd2si	rcx, xmm0
	shl	ecx, 8
	movzx	ecx, cx
	or	ecx, eax
	vminsd	xmm0, xmm2, xmm3
	vmulsd	xmm0, xmm0, xmm4
	vcvttsd2si	rax, xmm0
	movzx	eax, al
	or	eax, ecx
	mov	rcx, qword ptr [rsp + 104] # 8-byte Reload
	mov	dword ptr [rcx], eax
	mov	rax, rcx
	add	rax, 4
	add	r14d, 1
	cmp	r14d, dword ptr [rsp + 64] # 4-byte Folded Reload
	jne	.LBB3_4
# %bb.19:                               #   in Loop: Header=BB3_2 Depth=1
	mov	rax, qword ptr [rsp + 56] # 8-byte Reload
	mov	rcx, qword ptr [rsp + 88] # 8-byte Reload
	lea	rax, [rax + 4*rcx]
	mov	qword ptr [rsp + 56], rax # 8-byte Spill
.LBB3_20:                               #   in Loop: Header=BB3_2 Depth=1
	add	ebp, 1
	cmp	ebp, dword ptr [rsp + 76] # 4-byte Folded Reload
	jne	.LBB3_2
.LBB3_21:
	add	rsp, 424
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	ret
.Lfunc_end3:
	.size	render, .Lfunc_end3-render
	.cfi_endproc
                                        # -- End function
	.globl	trace                   # -- Begin function trace
	.p2align	4, 0x90
	.type	trace,@function
trace:                                  # @trace
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	sub	rsp, 216
	.cfi_def_cfa_offset 272
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	r15, rdi
	cmp	esi, 4
	jg	.LBB4_10
# %bb.1:
	mov	rax, qword ptr [rip + obj_list]
	mov	rbp, qword ptr [rax + 72]
	test	rbp, rbp
	je	.LBB4_10
# %bb.2:
	mov	r14d, esi
	lea	r13, [rsp + 272]
	xor	ebx, ebx
	lea	r12, [rsp + 136]
	.p2align	4, 0x90
.LBB4_3:                                # =>This Inner Loop Header: Depth=1
	vmovups	ymm0, ymmword ptr [r13]
	vmovups	ymm1, ymmword ptr [r13 + 16]
	vmovups	ymmword ptr [rsp + 16], ymm1
	vmovups	ymmword ptr [rsp], ymm0
	mov	rdi, rbp
	mov	rsi, r12
	vzeroupper
	call	ray_sphere
	test	eax, eax
	je	.LBB4_7
# %bb.4:                                #   in Loop: Header=BB4_3 Depth=1
	test	rbx, rbx
	je	.LBB4_6
# %bb.5:                                #   in Loop: Header=BB4_3 Depth=1
	vmovsd	xmm0, qword ptr [rsp + 120] # xmm0 = mem[0],zero
	vucomisd	xmm0, qword ptr [rsp + 208]
	jbe	.LBB4_7
.LBB4_6:                                #   in Loop: Header=BB4_3 Depth=1
	vmovups	ymm0, ymmword ptr [rsp + 136]
	vmovups	ymm1, ymmword ptr [rsp + 168]
	vmovups	ymm2, ymmword ptr [rsp + 184]
	vmovups	ymmword ptr [rsp + 96], ymm2
	vmovups	ymmword ptr [rsp + 80], ymm1
	vmovups	ymmword ptr [rsp + 48], ymm0
	mov	rbx, rbp
.LBB4_7:                                #   in Loop: Header=BB4_3 Depth=1
	mov	rbp, qword ptr [rbp + 72]
	test	rbp, rbp
	jne	.LBB4_3
# %bb.8:
	test	rbx, rbx
	je	.LBB4_10
# %bb.9:
	lea	rdx, [rsp + 48]
	mov	rdi, r15
	mov	rsi, rbx
	mov	ecx, r14d
	vzeroupper
	call	shade
	jmp	.LBB4_11
.LBB4_10:
	vxorps	xmm0, xmm0, xmm0
	vmovups	xmmword ptr [r15], xmm0
	mov	qword ptr [r15 + 16], 0
.LBB4_11:
	mov	rax, r15
	add	rsp, 216
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	ret
.Lfunc_end4:
	.size	trace, .Lfunc_end4-trace
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function get_primary_ray
.LCPI5_0:
	.quad	4611686018427387904     # double 2
.LCPI5_1:
	.quad	-4620693217682128896    # double -0.5
.LCPI5_2:
	.quad	-4619342137793917747    # double -0.65000000000000002
.LCPI5_4:
	.quad	4652007308841189376     # double 1000
.LCPI5_6:
	.quad	4657818181835467774     # double 2546.4791004857971
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI5_3:
	.quad	-9223372036854775808    # double -0
	.quad	-9223372036854775808    # double -0
.LCPI5_5:
	.quad	4657818181835467774     # double 2546.4791004857971
	.quad	4657818181835467774     # double 2546.4791004857971
	.text
	.globl	get_primary_ray
	.p2align	4, 0x90
	.type	get_primary_ray,@function
get_primary_ray:                        # @get_primary_ray
	.cfi_startproc
# %bb.0:
	push	r15
	.cfi_def_cfa_offset 16
	push	r14
	.cfi_def_cfa_offset 24
	push	r12
	.cfi_def_cfa_offset 32
	push	rbx
	.cfi_def_cfa_offset 40
	sub	rsp, 40
	.cfi_def_cfa_offset 80
	.cfi_offset rbx, -40
	.cfi_offset r12, -32
	.cfi_offset r14, -24
	.cfi_offset r15, -16
	mov	ebx, ecx
	mov	r15d, edx
	mov	r12d, esi
	mov	r14, rdi
	vmovupd	xmm0, xmmword ptr [rip + cam+24]
	vsubpd	xmm3, xmm0, xmmword ptr [rip + cam]
	vmovsd	xmm0, qword ptr [rip + cam+40] # xmm0 = mem[0],zero
	vsubsd	xmm4, xmm0, qword ptr [rip + cam+16]
	vmulsd	xmm0, xmm3, xmm3
	vpermilpd	xmm1, xmm3, 1   # xmm1 = xmm3[1,0]
	vmulsd	xmm1, xmm1, xmm1
	vaddsd	xmm0, xmm0, xmm1
	vmulsd	xmm1, xmm4, xmm4
	vaddsd	xmm0, xmm0, xmm1
	vxorps	xmm10, xmm10, xmm10
	vucomisd	xmm0, xmm10
	jb	.LBB5_2
# %bb.1:
	vsqrtsd	xmm0, xmm0, xmm0
	jmp	.LBB5_3
.LBB5_2:
	vmovapd	xmmword ptr [rsp + 16], xmm3 # 16-byte Spill
	vmovapd	xmmword ptr [rsp], xmm4 # 16-byte Spill
	call	sqrt
	vmovapd	xmm4, xmmword ptr [rsp] # 16-byte Reload
	vmovapd	xmm3, xmmword ptr [rsp + 16] # 16-byte Reload
	vxorps	xmm10, xmm10, xmm10
.LBB5_3:
	vmovq	xmm2, xmm0              # xmm2 = xmm0[0],zero
	vmovddup	xmm0, xmm0      # xmm0 = xmm0[0,0]
	vxorpd	xmm8, xmm8, xmm8
	vdivpd	xmm1, xmm3, xmm0
	vunpcklpd	xmm3, xmm4, xmm1 # xmm3 = xmm4[0],xmm1[0]
	vdivpd	xmm0, xmm3, xmm2
	vmulpd	xmm2, xmm3, xmm2
	vblendpd	xmm2, xmm2, xmm0, 1 # xmm2 = xmm0[0],xmm2[1]
	vpermilpd	xmm9, xmm1, 1   # xmm9 = xmm1[1,0]
	vshufpd	xmm4, xmm1, xmm0, 1     # xmm4 = xmm1[1],xmm0[0]
	vmulpd	xmm7, xmm4, xmm8
	vsubpd	xmm3, xmm2, xmm7
	vsubsd	xmm2, xmm7, xmm1
	vunpcklpd	xmm7, xmm2, xmm3 # xmm7 = xmm2[0],xmm3[0]
	vmulpd	xmm4, xmm4, xmm7
	vunpcklpd	xmm7, xmm0, xmm1 # xmm7 = xmm0[0],xmm1[0]
	vpermilpd	xmm5, xmm3, 1   # xmm5 = xmm3[1,0]
	vshufpd	xmm6, xmm3, xmm2, 1     # xmm6 = xmm3[1],xmm2[0]
	vmulpd	xmm6, xmm7, xmm6
	vsubpd	xmm4, xmm4, xmm6
	vmulsd	xmm5, xmm1, xmm5
	vmulsd	xmm6, xmm9, xmm3
	vsubsd	xmm7, xmm5, xmm6
	vmovupd	xmmword ptr [r14], xmm8
	mov	qword ptr [r14 + 16], 0
	vmovsd	xmm6, qword ptr [rip + get_sample_pos.sf] # xmm6 = mem[0],zero
	vcvtsi2sd	xmm5, xmm11, dword ptr [rip + xres]
	vucomisd	xmm6, xmm10
	jne	.LBB5_5
	jp	.LBB5_5
# %bb.4:
	vmovsd	xmm6, qword ptr [rip + .LCPI5_0] # xmm6 = mem[0],zero
	vdivsd	xmm6, xmm6, xmm5
	vmovsd	qword ptr [rip + get_sample_pos.sf], xmm6
.LBB5_5:
	vcvtpd2ps	xmm3, xmm3
	vcvtpd2ps	xmm4, xmm4
	vcvtpd2ps	xmm10, xmm1
	vcvtsd2ss	xmm11, xmm2, xmm2
	vcvtsd2ss	xmm9, xmm7, xmm7
	vcvtsd2ss	xmm8, xmm0, xmm0
	vcvtsi2sd	xmm0, xmm12, r12d
	vdivsd	xmm0, xmm0, xmm5
	vaddsd	xmm7, xmm0, qword ptr [rip + .LCPI5_1]
	vcvtsi2sd	xmm0, xmm12, r15d
	vcvtsi2sd	xmm1, xmm12, dword ptr [rip + yres]
	vdivsd	xmm0, xmm0, xmm1
	vaddsd	xmm0, xmm0, qword ptr [rip + .LCPI5_2]
	vxorpd	xmm0, xmm0, xmmword ptr [rip + .LCPI5_3]
	vmovsd	xmm1, qword ptr [rip + aspect] # xmm1 = mem[0],zero
	vdivsd	xmm0, xmm0, xmm1
	test	ebx, ebx
	je	.LBB5_7
# %bb.6:
	lea	eax, [r12 + 4*r15]
	mov	ecx, r12d
	add	ecx, ebx
	and	ecx, 1023
	add	eax, dword ptr [4*rcx + irand]
	and	eax, 1023
	lea	rax, [rax + 2*rax]
	lea	ecx, [r15 + 4*r12]
	add	ebx, r15d
	and	ebx, 1023
	add	ecx, dword ptr [4*rbx + irand]
	and	ecx, 1023
	lea	rcx, [rcx + 2*rcx]
	vmulsd	xmm5, xmm6, qword ptr [8*rax + urand]
	vaddsd	xmm7, xmm7, xmm5
	vmulsd	xmm5, xmm6, qword ptr [8*rcx + urand+8]
	vdivsd	xmm1, xmm5, xmm1
	vaddsd	xmm0, xmm0, xmm1
.LBB5_7:
	vmovsd	xmm1, qword ptr [rip + .LCPI5_4] # xmm1 = mem[0],zero
	vmulsd	xmm5, xmm7, xmm1
	vmulsd	xmm0, xmm0, xmm1
	vxorpd	xmm12, xmm12, xmm12
	vaddsd	xmm5, xmm5, xmm12
	vaddsd	xmm0, xmm0, xmm12
	vcvtps2pd	xmm3, xmm3
	vcvtps2pd	xmm4, xmm4
	vcvtps2pd	xmm6, xmm10
	vmovddup	xmm7, xmm5      # xmm7 = xmm5[0,0]
	vmulpd	xmm7, xmm7, xmm3
	vmovddup	xmm2, xmm0      # xmm2 = xmm0[0,0]
	vmulpd	xmm2, xmm2, xmm4
	vaddpd	xmm2, xmm2, xmm7
	vmulpd	xmm7, xmm6, xmmword ptr [rip + .LCPI5_5]
	vaddpd	xmm10, xmm7, xmm2
	vcvtss2sd	xmm7, xmm11, xmm11
	vmulsd	xmm5, xmm5, xmm7
	vcvtss2sd	xmm2, xmm9, xmm9
	vmulsd	xmm0, xmm0, xmm2
	vaddsd	xmm0, xmm0, xmm5
	vcvtss2sd	xmm5, xmm8, xmm8
	vmulsd	xmm1, xmm5, qword ptr [rip + .LCPI5_6]
	vaddsd	xmm0, xmm1, xmm0
	vxorpd	xmm1, xmm1, xmm1
	vmulpd	xmm3, xmm3, xmm1
	vmulpd	xmm4, xmm4, xmm1
	vaddpd	xmm3, xmm3, xmm4
	vmulpd	xmm1, xmm6, xmm1
	vaddpd	xmm1, xmm1, xmm3
	vaddpd	xmm1, xmm1, xmmword ptr [rip + cam]
	vmulsd	xmm3, xmm7, xmm12
	vmulsd	xmm2, xmm2, xmm12
	vaddsd	xmm2, xmm3, xmm2
	vmulsd	xmm3, xmm5, xmm12
	vaddsd	xmm2, xmm3, xmm2
	vaddsd	xmm2, xmm2, qword ptr [rip + cam+16]
	vmovupd	xmmword ptr [r14], xmm1
	vmovsd	qword ptr [r14 + 16], xmm2
	vaddpd	xmm1, xmm10, xmm1
	vmovupd	xmmword ptr [r14 + 24], xmm1
	vaddsd	xmm0, xmm0, xmm2
	vmovsd	qword ptr [r14 + 40], xmm0
	mov	rax, r14
	add	rsp, 40
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end5:
	.size	get_primary_ray, .Lfunc_end5-get_primary_ray
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4               # -- Begin function ray_sphere
.LCPI6_0:
	.quad	-9223372036854775808    # double -0
	.quad	-9223372036854775808    # double -0
.LCPI6_3:
	.quad	4607182418800017408     # double 1
	.quad	4607182418800017408     # double 1
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI6_1:
	.quad	-4607182418800017408    # double -4
.LCPI6_2:
	.quad	4517329193108106637     # double 9.9999999999999995E-7
	.text
	.globl	ray_sphere
	.p2align	4, 0x90
	.type	ray_sphere,@function
ray_sphere:                             # @ray_sphere
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r14
	.cfi_def_cfa_offset 24
	push	rbx
	.cfi_def_cfa_offset 32
	sub	rsp, 80
	.cfi_def_cfa_offset 112
	.cfi_offset rbx, -32
	.cfi_offset r14, -24
	.cfi_offset rbp, -16
	vmovupd	xmm9, xmmword ptr [rsp + 136]
	vmulpd	xmm0, xmm9, xmm9
	vpermilpd	xmm1, xmm0, 1   # xmm1 = xmm0[1,0]
	vaddsd	xmm0, xmm0, xmm1
	vmovsd	xmm8, qword ptr [rsp + 152] # xmm8 = mem[0],zero
	vmulsd	xmm1, xmm8, xmm8
	vaddsd	xmm5, xmm0, xmm1
	vmovapd	xmm7, xmmword ptr [rsp + 112]
	vmovupd	xmm0, xmmword ptr [rdi]
	vaddpd	xmm1, xmm9, xmm9
	vsubpd	xmm2, xmm7, xmm0
	vmulpd	xmm1, xmm1, xmm2
	vpermilpd	xmm2, xmm1, 1   # xmm2 = xmm1[1,0]
	vaddsd	xmm1, xmm1, xmm2
	vaddsd	xmm2, xmm8, xmm8
	vmovsd	xmm6, qword ptr [rsp + 128] # xmm6 = mem[0],zero
	vmovsd	xmm3, qword ptr [rdi + 16] # xmm3 = mem[0],zero
	vsubsd	xmm4, xmm6, xmm3
	vmulsd	xmm2, xmm2, xmm4
	vaddsd	xmm4, xmm1, xmm2
	vmulpd	xmm1, xmm0, xmm0
	vpermilpd	xmm2, xmm1, 1   # xmm2 = xmm1[1,0]
	vaddsd	xmm1, xmm1, xmm2
	vmulsd	xmm2, xmm3, xmm3
	vaddsd	xmm1, xmm1, xmm2
	vmulpd	xmm2, xmm7, xmm7
	vaddsd	xmm1, xmm2, xmm1
	vpermilpd	xmm2, xmm2, 1   # xmm2 = xmm2[1,0]
	vaddsd	xmm1, xmm2, xmm1
	vmulsd	xmm2, xmm6, xmm6
	vaddsd	xmm1, xmm2, xmm1
	vmulpd	xmm0, xmm7, xmm0
	vxorpd	xmm2, xmm0, xmmword ptr [rip + .LCPI6_0]
	vpermilpd	xmm0, xmm0, 1   # xmm0 = xmm0[1,0]
	vsubsd	xmm0, xmm2, xmm0
	vmulsd	xmm2, xmm6, xmm3
	vsubsd	xmm0, xmm0, xmm2
	vaddsd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, xmm1
	vmovsd	xmm1, qword ptr [rdi + 24] # xmm1 = mem[0],zero
	vmulsd	xmm1, xmm1, xmm1
	vsubsd	xmm0, xmm0, xmm1
	vmulsd	xmm1, xmm4, xmm4
	vmulsd	xmm2, xmm5, qword ptr [rip + .LCPI6_1]
	vmulsd	xmm0, xmm2, xmm0
	vaddsd	xmm0, xmm1, xmm0
	xor	ebp, ebp
	vxorpd	xmm1, xmm1, xmm1
	vucomisd	xmm1, xmm0
	ja	.LBB6_13
# %bb.1:
	mov	r14, rsi
	mov	rbx, rdi
	vucomisd	xmm0, xmm1
	jb	.LBB6_3
# %bb.2:
	vsqrtsd	xmm0, xmm0, xmm0
	jmp	.LBB6_4
.LBB6_3:
	vmovapd	xmmword ptr [rsp + 64], xmm9 # 16-byte Spill
	vmovsd	qword ptr [rsp + 24], xmm8 # 8-byte Spill
	vmovapd	xmmword ptr [rsp + 48], xmm7 # 16-byte Spill
	vmovsd	qword ptr [rsp + 16], xmm6 # 8-byte Spill
	vmovsd	qword ptr [rsp + 8], xmm5 # 8-byte Spill
	vmovapd	xmmword ptr [rsp + 32], xmm4 # 16-byte Spill
	call	sqrt
	vmovapd	xmm4, xmmword ptr [rsp + 32] # 16-byte Reload
	vmovsd	xmm5, qword ptr [rsp + 8] # 8-byte Reload
                                        # xmm5 = mem[0],zero
	vmovsd	xmm6, qword ptr [rsp + 16] # 8-byte Reload
                                        # xmm6 = mem[0],zero
	vmovapd	xmm7, xmmword ptr [rsp + 48] # 16-byte Reload
	vmovsd	xmm8, qword ptr [rsp + 24] # 8-byte Reload
                                        # xmm8 = mem[0],zero
	vmovapd	xmm9, xmmword ptr [rsp + 64] # 16-byte Reload
.LBB6_4:
	vxorpd	xmm1, xmm4, xmmword ptr [rip + .LCPI6_0]
	vaddsd	xmm2, xmm5, xmm5
	vunpcklpd	xmm1, xmm0, xmm1 # xmm1 = xmm0[0],xmm1[0]
	vunpcklpd	xmm0, xmm4, xmm0 # xmm0 = xmm4[0],xmm0[0]
	vsubpd	xmm0, xmm1, xmm0
	vmovddup	xmm1, xmm2      # xmm1 = xmm2[0,0]
	vdivpd	xmm0, xmm0, xmm1
	vmovsd	xmm1, qword ptr [rip + .LCPI6_2] # xmm1 = mem[0],zero
	vucomisd	xmm1, xmm0
	vpermilpd	xmm2, xmm0, 1   # xmm2 = xmm0[1,0]
	jbe	.LBB6_6
# %bb.5:
	vucomisd	xmm1, xmm2
	ja	.LBB6_13
.LBB6_6:
	vmovapd	xmm3, xmmword ptr [rip + .LCPI6_3] # xmm3 = [1.000000e+00,1.000000e+00]
	vcmpltpd	xmm3, xmm3, xmm0
	vpextrb	eax, xmm3, 0
	test	al, 1
	je	.LBB6_8
# %bb.7:
	vpextrb	eax, xmm3, 8
	test	al, 1
	jne	.LBB6_13
.LBB6_8:
	mov	ebp, 1
	test	r14, r14
	je	.LBB6_13
# %bb.9:
	vcmpltsd	xmm3, xmm0, xmm1
	vblendvpd	xmm0, xmm0, xmm2, xmm3
	vcmpltsd	xmm1, xmm2, xmm1
	vblendvpd	xmm1, xmm2, xmm0, xmm1
	vminsd	xmm0, xmm0, xmm1
	vmovsd	qword ptr [r14 + 72], xmm0
	vmovddup	xmm1, xmm0      # xmm1 = xmm0[0,0]
	vmulpd	xmm1, xmm9, xmm1
	vaddpd	xmm1, xmm7, xmm1
	vmovupd	xmmword ptr [r14], xmm1
	vmulsd	xmm0, xmm8, xmm0
	vaddsd	xmm0, xmm6, xmm0
	vmovsd	qword ptr [r14 + 16], xmm0
	vmovsd	xmm2, qword ptr [rbx + 24] # xmm2 = mem[0],zero
	vsubpd	xmm1, xmm1, xmmword ptr [rbx]
	vmovddup	xmm3, xmm2      # xmm3 = xmm2[0,0]
	vdivpd	xmm1, xmm1, xmm3
	vmovupd	xmmword ptr [r14 + 24], xmm1
	vsubsd	xmm0, xmm0, qword ptr [rbx + 16]
	vdivsd	xmm0, xmm0, xmm2
	vmovsd	qword ptr [r14 + 40], xmm0
	vmulsd	xmm2, xmm1, xmm9
	vpermilpd	xmm3, xmm9, 1   # xmm3 = xmm9[1,0]
	vpermilpd	xmm4, xmm1, 1   # xmm4 = xmm1[1,0]
	vmulsd	xmm3, xmm3, xmm4
	vaddsd	xmm2, xmm3, xmm2
	vmulsd	xmm3, xmm8, xmm0
	vaddsd	xmm2, xmm3, xmm2
	vaddsd	xmm2, xmm2, xmm2
	vmovddup	xmm3, xmm2      # xmm3 = xmm2[0,0]
	vmulpd	xmm1, xmm1, xmm3
	vsubpd	xmm1, xmm1, xmm9
	vmovapd	xmm3, xmmword ptr [rip + .LCPI6_0] # xmm3 = [-0.000000e+00,-0.000000e+00]
	vxorpd	xmm4, xmm1, xmm3
	vmulsd	xmm0, xmm0, xmm2
	vsubsd	xmm0, xmm0, xmm8
	vxorpd	xmm2, xmm0, xmm3
	vmovupd	xmmword ptr [r14 + 48], xmm4
	vmovlpd	qword ptr [r14 + 64], xmm2
	vmulsd	xmm2, xmm1, xmm1
	vpermilpd	xmm1, xmm1, 1   # xmm1 = xmm1[1,0]
	vmulsd	xmm1, xmm1, xmm1
	vaddsd	xmm1, xmm2, xmm1
	vmulsd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, xmm1
	vxorpd	xmm1, xmm1, xmm1
	vucomisd	xmm0, xmm1
	jb	.LBB6_11
# %bb.10:
	vsqrtsd	xmm0, xmm0, xmm0
	jmp	.LBB6_12
.LBB6_11:
	call	sqrt
.LBB6_12:
	vmovsd	xmm1, qword ptr [r14 + 48] # xmm1 = mem[0],zero
	vmovsd	xmm2, qword ptr [r14 + 56] # xmm2 = mem[0],zero
	vdivsd	xmm1, xmm1, xmm0
	vmovsd	qword ptr [r14 + 48], xmm1
	vdivsd	xmm1, xmm2, xmm0
	vmovsd	qword ptr [r14 + 56], xmm1
	vmovsd	xmm1, qword ptr [r14 + 64] # xmm1 = mem[0],zero
	vdivsd	xmm0, xmm1, xmm0
	vmovsd	qword ptr [r14 + 64], xmm0
.LBB6_13:
	mov	eax, ebp
	add	rsp, 80
	.cfi_def_cfa_offset 32
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end6:
	.size	ray_sphere, .Lfunc_end6-ray_sphere
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function shade
.LCPI7_0:
	.quad	4616189618054758400     # double 4
.LCPI7_2:
	.quad	4517329193108106637     # double 9.9999999999999995E-7
.LCPI7_5:
	.quad	4652007308841189376     # double 1000
.LCPI7_6:
	.quad	0                       # double 0
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI7_1:
	.quad	-9223372036854775808    # double -0
	.quad	-9223372036854775808    # double -0
.LCPI7_3:
	.quad	4607182418800017408     # double 1
	.quad	4607182418800017408     # double 1
.LCPI7_4:
	.quad	4652007308841189376     # double 1000
	.quad	4652007308841189376     # double 1000
	.text
	.globl	shade
	.p2align	4, 0x90
	.type	shade,@function
shade:                                  # @shade
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	sub	rsp, 520
	.cfi_def_cfa_offset 576
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	r13d, ecx
	mov	r12, rdx
	mov	r15, rsi
	mov	r14, rdi
	vxorpd	xmm1, xmm1, xmm1
	vxorpd	xmm0, xmm0, xmm0
	vmovapd	xmmword ptr [rsp + 96], xmm0 # 16-byte Spill
	vmovupd	xmmword ptr [rdi], xmm1
	mov	qword ptr [rdi + 16], 0
	cmp	dword ptr [rip + lnum], 0
	vxorpd	xmm0, xmm0, xmm0
	vmovsd	qword ptr [rsp + 56], xmm0 # 8-byte Spill
	jle	.LBB7_20
# %bb.1:
	vxorpd	xmm0, xmm0, xmm0
	vmovapd	xmmword ptr [rsp + 96], xmm0 # 16-byte Spill
	vxorpd	xmm7, xmm7, xmm7
	xor	ebx, ebx
	vmovapd	xmm6, xmmword ptr [rip + .LCPI7_1] # xmm6 = [-0.000000e+00,-0.000000e+00]
	vxorpd	xmm0, xmm0, xmm0
	vmovsd	qword ptr [rsp + 56], xmm0 # 8-byte Spill
	.p2align	4, 0x90
.LBB7_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB7_4 Depth 2
	mov	rax, qword ptr [rip + obj_list]
	lea	rcx, [8*rbx]
	vmovsd	xmm0, qword ptr [rcx + 2*rcx + lights] # xmm0 = mem[0],zero
	vmovsd	xmm9, qword ptr [r12]   # xmm9 = mem[0],zero
	vmovsd	xmm5, qword ptr [r12 + 8] # xmm5 = mem[0],zero
	vmovsd	xmm1, qword ptr [rcx + 2*rcx + lights+8] # xmm1 = mem[0],zero
	vsubsd	xmm1, xmm1, xmm5
	vmovsd	xmm10, qword ptr [r12 + 16] # xmm10 = mem[0],zero
	vmovhpd	xmm0, xmm0, qword ptr [rcx + 2*rcx + lights+16] # xmm0 = xmm0[0],mem[0]
	vunpcklpd	xmm11, xmm9, xmm10 # xmm11 = xmm9[0],xmm10[0]
	vsubpd	xmm2, xmm0, xmm11
	mov	rbp, qword ptr [rax + 72]
	test	rbp, rbp
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	qword ptr [rsp + 88], xmm1 # 8-byte Spill
	vmulsd	xmm1, xmm1, xmm1
	vaddsd	xmm0, xmm0, xmm1
	vmovapd	xmmword ptr [rsp + 160], xmm2 # 16-byte Spill
	vpermilpd	xmm1, xmm2, 1   # xmm1 = xmm2[1,0]
	vmulsd	xmm1, xmm1, xmm1
	vaddsd	xmm0, xmm0, xmm1
	vmovsd	qword ptr [rsp + 80], xmm0 # 8-byte Spill
	je	.LBB7_13
# %bb.3:                                #   in Loop: Header=BB7_2 Depth=1
	vmovsd	xmm0, qword ptr [rsp + 88] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vaddsd	xmm12, xmm0, xmm0
	vmovapd	xmm0, xmmword ptr [rsp + 160] # 16-byte Reload
	vaddpd	xmm13, xmm0, xmm0
	vmulsd	xmm14, xmm9, xmm9
	vmulsd	xmm15, xmm5, xmm5
	vmulsd	xmm0, xmm10, xmm10
	vmovsd	qword ptr [rsp + 64], xmm0 # 8-byte Spill
	vmovsd	xmm0, qword ptr [rsp + 80] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmulsd	xmm1, xmm0, qword ptr [rip + .LCPI7_0]
	vmovsd	qword ptr [rsp + 152], xmm1 # 8-byte Spill
	vaddsd	xmm0, xmm0, xmm0
	vmovddup	xmm0, xmm0      # xmm0 = xmm0[0,0]
	vmovapd	xmmword ptr [rsp + 256], xmm0 # 16-byte Spill
	vmovapd	xmmword ptr [rsp + 224], xmm9 # 16-byte Spill
	vmovsd	qword ptr [rsp + 144], xmm5 # 8-byte Spill
	vmovapd	xmmword ptr [rsp + 208], xmm10 # 16-byte Spill
	vmovapd	xmmword ptr [rsp + 192], xmm11 # 16-byte Spill
	vmovsd	qword ptr [rsp + 136], xmm12 # 8-byte Spill
	vmovapd	xmmword ptr [rsp + 176], xmm13 # 16-byte Spill
	vmovsd	qword ptr [rsp + 128], xmm14 # 8-byte Spill
	vmovsd	qword ptr [rsp + 120], xmm15 # 8-byte Spill
	.p2align	4, 0x90
.LBB7_4:                                #   Parent Loop BB7_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovsd	xmm0, qword ptr [rbp]   # xmm0 = mem[0],zero
	vmovsd	xmm1, qword ptr [rbp + 8] # xmm1 = mem[0],zero
	vsubsd	xmm2, xmm5, xmm1
	vmulsd	xmm2, xmm12, xmm2
	vmovsd	xmm3, qword ptr [rbp + 16] # xmm3 = mem[0],zero
	vunpcklpd	xmm4, xmm0, xmm3 # xmm4 = xmm0[0],xmm3[0]
	vsubpd	xmm4, xmm11, xmm4
	vmulpd	xmm4, xmm13, xmm4
	vaddsd	xmm2, xmm4, xmm2
	vpermilpd	xmm4, xmm4, 1   # xmm4 = xmm4[1,0]
	vaddsd	xmm8, xmm2, xmm4
	vmulsd	xmm2, xmm0, xmm0
	vmulsd	xmm4, xmm1, xmm1
	vaddsd	xmm2, xmm2, xmm4
	vmulsd	xmm4, xmm3, xmm3
	vaddsd	xmm2, xmm2, xmm4
	vaddsd	xmm2, xmm14, xmm2
	vaddsd	xmm2, xmm15, xmm2
	vaddsd	xmm2, xmm2, qword ptr [rsp + 64] # 8-byte Folded Reload
	vmulsd	xmm0, xmm9, xmm0
	vxorpd	xmm0, xmm0, xmm6
	vmulsd	xmm1, xmm5, xmm1
	vsubsd	xmm0, xmm0, xmm1
	vmulsd	xmm1, xmm10, xmm3
	vsubsd	xmm0, xmm0, xmm1
	vaddsd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, xmm2
	vmovsd	xmm1, qword ptr [rbp + 24] # xmm1 = mem[0],zero
	vmulsd	xmm1, xmm1, xmm1
	vsubsd	xmm0, xmm0, xmm1
	vmulsd	xmm0, xmm0, qword ptr [rsp + 152] # 8-byte Folded Reload
	vmulsd	xmm1, xmm8, xmm8
	vsubsd	xmm0, xmm1, xmm0
	vucomisd	xmm7, xmm0
	ja	.LBB7_12
# %bb.5:                                #   in Loop: Header=BB7_4 Depth=2
	vucomisd	xmm0, xmm7
	jb	.LBB7_7
# %bb.6:                                #   in Loop: Header=BB7_4 Depth=2
	vsqrtsd	xmm0, xmm0, xmm0
	jmp	.LBB7_8
	.p2align	4, 0x90
.LBB7_7:                                #   in Loop: Header=BB7_4 Depth=2
	vmovapd	xmmword ptr [rsp + 240], xmm8 # 16-byte Spill
	call	sqrt
	vmovapd	xmm8, xmmword ptr [rsp + 240] # 16-byte Reload
	vmovsd	xmm15, qword ptr [rsp + 120] # 8-byte Reload
                                        # xmm15 = mem[0],zero
	vmovsd	xmm14, qword ptr [rsp + 128] # 8-byte Reload
                                        # xmm14 = mem[0],zero
	vmovapd	xmm13, xmmword ptr [rsp + 176] # 16-byte Reload
	vmovsd	xmm12, qword ptr [rsp + 136] # 8-byte Reload
                                        # xmm12 = mem[0],zero
	vmovapd	xmm11, xmmword ptr [rsp + 192] # 16-byte Reload
	vmovapd	xmm10, xmmword ptr [rsp + 208] # 16-byte Reload
	vmovsd	xmm5, qword ptr [rsp + 144] # 8-byte Reload
                                        # xmm5 = mem[0],zero
	vmovapd	xmm9, xmmword ptr [rsp + 224] # 16-byte Reload
	vmovapd	xmm6, xmmword ptr [rip + .LCPI7_1] # xmm6 = [-0.000000e+00,-0.000000e+00]
	vxorpd	xmm7, xmm7, xmm7
.LBB7_8:                                #   in Loop: Header=BB7_4 Depth=2
	vxorpd	xmm1, xmm8, xmm6
	vunpcklpd	xmm1, xmm0, xmm1 # xmm1 = xmm0[0],xmm1[0]
	vunpcklpd	xmm0, xmm8, xmm0 # xmm0 = xmm8[0],xmm0[0]
	vsubpd	xmm0, xmm1, xmm0
	vdivpd	xmm0, xmm0, xmmword ptr [rsp + 256] # 16-byte Folded Reload
	vmovsd	xmm1, qword ptr [rip + .LCPI7_2] # xmm1 = mem[0],zero
	vucomisd	xmm1, xmm0
	jbe	.LBB7_10
# %bb.9:                                #   in Loop: Header=BB7_4 Depth=2
	vpermilpd	xmm1, xmm0, 1   # xmm1 = xmm0[1,0]
	vmovsd	xmm2, qword ptr [rip + .LCPI7_2] # xmm2 = mem[0],zero
	vucomisd	xmm2, xmm1
	ja	.LBB7_12
.LBB7_10:                               #   in Loop: Header=BB7_4 Depth=2
	vmovapd	xmm1, xmmword ptr [rip + .LCPI7_3] # xmm1 = [1.000000e+00,1.000000e+00]
	vcmpltpd	xmm0, xmm1, xmm0
	vpextrb	eax, xmm0, 0
	test	al, 1
	je	.LBB7_19
# %bb.11:                               #   in Loop: Header=BB7_4 Depth=2
	vpextrb	eax, xmm0, 8
	test	al, 1
	je	.LBB7_19
.LBB7_12:                               #   in Loop: Header=BB7_4 Depth=2
	mov	rbp, qword ptr [rbp + 72]
	test	rbp, rbp
	jne	.LBB7_4
.LBB7_13:                               #   in Loop: Header=BB7_2 Depth=1
	vmovsd	xmm0, qword ptr [rsp + 80] # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vucomisd	xmm0, xmm7
	jb	.LBB7_15
# %bb.14:                               #   in Loop: Header=BB7_2 Depth=1
	vsqrtsd	xmm0, xmm0, xmm0
	jmp	.LBB7_16
	.p2align	4, 0x90
.LBB7_15:                               #   in Loop: Header=BB7_2 Depth=1
	call	sqrt
	vmovapd	xmm6, xmmword ptr [rip + .LCPI7_1] # xmm6 = [-0.000000e+00,-0.000000e+00]
	vxorpd	xmm7, xmm7, xmm7
.LBB7_16:                               #   in Loop: Header=BB7_2 Depth=1
	vmovsd	xmm1, qword ptr [rsp + 88] # 8-byte Reload
                                        # xmm1 = mem[0],zero
	vdivsd	xmm3, xmm1, xmm0
	vmovddup	xmm0, xmm0      # xmm0 = xmm0[0,0]
	vmovapd	xmm1, xmmword ptr [rsp + 160] # 16-byte Reload
	vdivpd	xmm2, xmm1, xmm0
	vmulsd	xmm0, xmm2, qword ptr [r12 + 24]
	vmulsd	xmm1, xmm3, qword ptr [r12 + 32]
	vaddsd	xmm0, xmm0, xmm1
	vpermilpd	xmm1, xmm2, 1   # xmm1 = xmm2[1,0]
	vmulsd	xmm1, xmm1, qword ptr [r12 + 40]
	vaddsd	xmm1, xmm0, xmm1
	vxorpd	xmm0, xmm0, xmm0
	vmaxsd	xmm4, xmm1, xmm0
	vmovsd	xmm1, qword ptr [r15 + 56] # xmm1 = mem[0],zero
	vucomisd	xmm1, xmm0
	jbe	.LBB7_18
# %bb.17:                               #   in Loop: Header=BB7_2 Depth=1
	vmovsd	xmm0, qword ptr [r12 + 48] # xmm0 = mem[0],zero
	vmulsd	xmm3, xmm3, qword ptr [r12 + 56]
	vmovhpd	xmm0, xmm0, qword ptr [r12 + 64] # xmm0 = xmm0[0],mem[0]
	vmulpd	xmm0, xmm2, xmm0
	vaddsd	xmm2, xmm0, xmm3
	vpermilpd	xmm0, xmm0, 1   # xmm0 = xmm0[1,0]
	vaddsd	xmm0, xmm2, xmm0
	vmaxsd	xmm0, xmm0, xmm7
	vmovapd	xmmword ptr [rsp + 64], xmm4 # 16-byte Spill
	call	pow
	vmovapd	xmm4, xmmword ptr [rsp + 64] # 16-byte Reload
	vmovapd	xmm6, xmmword ptr [rip + .LCPI7_1] # xmm6 = [-0.000000e+00,-0.000000e+00]
	vxorpd	xmm7, xmm7, xmm7
.LBB7_18:                               #   in Loop: Header=BB7_2 Depth=1
	vmovddup	xmm1, xmm4      # xmm1 = xmm4[0,0]
	vmulpd	xmm1, xmm1, xmmword ptr [r15 + 32]
	vmovddup	xmm2, xmm0      # xmm2 = xmm0[0,0]
	vaddpd	xmm1, xmm2, xmm1
	vmovapd	xmm2, xmmword ptr [rsp + 96] # 16-byte Reload
	vaddpd	xmm2, xmm2, xmm1
	vmovapd	xmmword ptr [rsp + 96], xmm2 # 16-byte Spill
	vmovupd	xmmword ptr [r14], xmm2
	vmulsd	xmm1, xmm4, qword ptr [r15 + 48]
	vaddsd	xmm0, xmm0, xmm1
	vmovsd	xmm1, qword ptr [rsp + 56] # 8-byte Reload
                                        # xmm1 = mem[0],zero
	vaddsd	xmm1, xmm1, xmm0
	vmovsd	qword ptr [rsp + 56], xmm1 # 8-byte Spill
	vmovsd	qword ptr [r14 + 16], xmm1
.LBB7_19:                               #   in Loop: Header=BB7_2 Depth=1
	add	rbx, 1
	movsxd	rax, dword ptr [rip + lnum]
	cmp	rbx, rax
	jl	.LBB7_2
.LBB7_20:
	vmovsd	xmm0, qword ptr [r15 + 64] # xmm0 = mem[0],zero
	vucomisd	xmm0, qword ptr [.LCPI7_6]
	jbe	.LBB7_32
# %bb.21:
	vmovupd	xmm0, xmmword ptr [r12 + 48]
	vmovsd	xmm1, qword ptr [r12 + 64] # xmm1 = mem[0],zero
	vmulpd	xmm0, xmm0, xmmword ptr [rip + .LCPI7_4]
	vmulsd	xmm1, xmm1, qword ptr [rip + .LCPI7_5]
	mov	rax, qword ptr [r12 + 16]
	mov	qword ptr [rsp + 288], rax
	vmovupd	xmm2, xmmword ptr [r12]
	vmovapd	xmmword ptr [rsp + 272], xmm2
	vmovupd	xmmword ptr [rsp + 296], xmm0
	vmovsd	qword ptr [rsp + 312], xmm1
	vxorpd	xmm0, xmm0, xmm0
	vmovapd	xmmword ptr [rsp + 64], xmm0 # 16-byte Spill
	vxorpd	xmm2, xmm2, xmm2
	cmp	r13d, 3
	jg	.LBB7_31
# %bb.22:
	mov	rax, qword ptr [rip + obj_list]
	mov	rbp, qword ptr [rax + 72]
	test	rbp, rbp
	je	.LBB7_31
# %bb.23:
	add	r13d, 1
	mov	ebx, r13d
	xor	r12d, r12d
	lea	r13, [rsp + 440]
	.p2align	4, 0x90
.LBB7_24:                               # =>This Inner Loop Header: Depth=1
	vmovupd	ymm0, ymmword ptr [rsp + 272]
	vmovupd	ymm1, ymmword ptr [rsp + 288]
	vmovupd	ymmword ptr [rsp + 16], ymm1
	vmovupd	ymmword ptr [rsp], ymm0
	mov	rdi, rbp
	mov	rsi, r13
	vzeroupper
	call	ray_sphere
	test	eax, eax
	je	.LBB7_28
# %bb.25:                               #   in Loop: Header=BB7_24 Depth=1
	test	r12, r12
	je	.LBB7_27
# %bb.26:                               #   in Loop: Header=BB7_24 Depth=1
	vmovsd	xmm0, qword ptr [rsp + 424] # xmm0 = mem[0],zero
	vucomisd	xmm0, qword ptr [rsp + 512]
	jbe	.LBB7_28
.LBB7_27:                               #   in Loop: Header=BB7_24 Depth=1
	vmovupd	ymm0, ymmword ptr [rsp + 440]
	vmovupd	ymm1, ymmword ptr [rsp + 472]
	vmovupd	ymm2, ymmword ptr [rsp + 488]
	vmovupd	ymmword ptr [rsp + 400], ymm2
	vmovupd	ymmword ptr [rsp + 384], ymm1
	vmovupd	ymmword ptr [rsp + 352], ymm0
	mov	r12, rbp
.LBB7_28:                               #   in Loop: Header=BB7_24 Depth=1
	mov	rbp, qword ptr [rbp + 72]
	test	rbp, rbp
	jne	.LBB7_24
# %bb.29:
	test	r12, r12
	vxorpd	xmm2, xmm2, xmm2
	je	.LBB7_31
# %bb.30:
	lea	rdi, [rsp + 320]
	lea	rdx, [rsp + 352]
	mov	rsi, r12
	mov	ecx, ebx
	vzeroupper
	call	shade
	vmovapd	xmm0, xmmword ptr [rsp + 320]
	vmovapd	xmmword ptr [rsp + 64], xmm0 # 16-byte Spill
	vmovsd	xmm2, qword ptr [rsp + 336] # xmm2 = mem[0],zero
.LBB7_31:
	vmovsd	xmm0, qword ptr [r15 + 64] # xmm0 = mem[0],zero
	vmovddup	xmm1, xmm0      # xmm1 = xmm0[0,0]
	vmulpd	xmm1, xmm1, xmmword ptr [rsp + 64] # 16-byte Folded Reload
	vaddpd	xmm1, xmm1, xmmword ptr [rsp + 96] # 16-byte Folded Reload
	vmovupd	xmmword ptr [r14], xmm1
	vmulsd	xmm0, xmm2, xmm0
	vaddsd	xmm0, xmm0, qword ptr [rsp + 56] # 8-byte Folded Reload
	vmovsd	qword ptr [r14 + 16], xmm0
.LBB7_32:
	mov	rax, r14
	add	rsp, 520
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	ret
.Lfunc_end7:
	.size	shade, .Lfunc_end7-shade
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4               # -- Begin function reflect
.LCPI8_0:
	.quad	-9223372036854775808    # double -0
	.quad	-9223372036854775808    # double -0
	.text
	.globl	reflect
	.p2align	4, 0x90
	.type	reflect,@function
reflect:                                # @reflect
	.cfi_startproc
# %bb.0:
	vmovapd	xmm0, xmmword ptr [rsp + 8]
	vmovupd	xmm1, xmmword ptr [rsp + 32]
	vmulsd	xmm2, xmm0, xmm1
	vpermilpd	xmm3, xmm1, 1   # xmm3 = xmm1[1,0]
	vpermilpd	xmm4, xmm0, 1   # xmm4 = xmm0[1,0]
	vmulsd	xmm3, xmm4, xmm3
	vaddsd	xmm2, xmm2, xmm3
	vmovsd	xmm3, qword ptr [rsp + 24] # xmm3 = mem[0],zero
	vmovsd	xmm4, qword ptr [rsp + 48] # xmm4 = mem[0],zero
	vmulsd	xmm5, xmm3, xmm4
	vaddsd	xmm2, xmm2, xmm5
	vaddsd	xmm2, xmm2, xmm2
	vmovddup	xmm5, xmm2      # xmm5 = xmm2[0,0]
	vmulpd	xmm1, xmm1, xmm5
	vsubpd	xmm0, xmm1, xmm0
	vmovapd	xmm1, xmmword ptr [rip + .LCPI8_0] # xmm1 = [-0.000000e+00,-0.000000e+00]
	vxorpd	xmm0, xmm0, xmm1
	vmovupd	xmmword ptr [rdi], xmm0
	vmulsd	xmm0, xmm4, xmm2
	vsubsd	xmm0, xmm0, xmm3
	vxorpd	xmm0, xmm0, xmm1
	vmovlpd	qword ptr [rdi + 16], xmm0
	mov	rax, rdi
	ret
.Lfunc_end8:
	.size	reflect, .Lfunc_end8-reflect
	.cfi_endproc
                                        # -- End function
	.globl	cross_product           # -- Begin function cross_product
	.p2align	4, 0x90
	.type	cross_product,@function
cross_product:                          # @cross_product
	.cfi_startproc
# %bb.0:
	vmovupd	xmm0, xmmword ptr [rsp + 16]
	vmovupd	xmm1, xmmword ptr [rsp + 40]
	vmovsd	xmm2, qword ptr [rsp + 32] # xmm2 = mem[0],zero
	vshufpd	xmm3, xmm1, xmm2, 1     # xmm3 = xmm1[1],xmm2[0]
	vmulpd	xmm3, xmm0, xmm3
	vmovsd	xmm4, qword ptr [rsp + 8] # xmm4 = mem[0],zero
	vshufpd	xmm5, xmm0, xmm4, 1     # xmm5 = xmm0[1],xmm4[0]
	vmulpd	xmm5, xmm5, xmm1
	vsubpd	xmm3, xmm3, xmm5
	vmovupd	xmmword ptr [rdi], xmm3
	vmulsd	xmm1, xmm1, xmm4
	vmulsd	xmm0, xmm0, xmm2
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	qword ptr [rdi + 16], xmm0
	mov	rax, rdi
	ret
.Lfunc_end9:
	.size	cross_product, .Lfunc_end9-cross_product
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function get_sample_pos
.LCPI10_0:
	.quad	4611686018427387904     # double 2
.LCPI10_1:
	.quad	-4620693217682128896    # double -0.5
.LCPI10_2:
	.quad	-4619342137793917747    # double -0.65000000000000002
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI10_3:
	.quad	-9223372036854775808    # double -0
	.quad	-9223372036854775808    # double -0
	.text
	.globl	get_sample_pos
	.p2align	4, 0x90
	.type	get_sample_pos,@function
get_sample_pos:                         # @get_sample_pos
	.cfi_startproc
# %bb.0:
                                        # kill: def $ecx killed $ecx def $rcx
                                        # kill: def $edx killed $edx def $rdx
                                        # kill: def $esi killed $esi def $rsi
	vmovsd	xmm0, qword ptr [rip + get_sample_pos.sf] # xmm0 = mem[0],zero
	vcvtsi2sd	xmm1, xmm1, dword ptr [rip + xres]
	vxorps	xmm2, xmm2, xmm2
	vucomisd	xmm0, xmm2
	jne	.LBB10_2
	jp	.LBB10_2
# %bb.1:
	vmovsd	xmm0, qword ptr [rip + .LCPI10_0] # xmm0 = mem[0],zero
	vdivsd	xmm0, xmm0, xmm1
	vmovsd	qword ptr [rip + get_sample_pos.sf], xmm0
.LBB10_2:
	vcvtsi2sd	xmm2, xmm3, esi
	vdivsd	xmm1, xmm2, xmm1
	vaddsd	xmm1, xmm1, qword ptr [rip + .LCPI10_1]
	vmovsd	qword ptr [rdi], xmm1
	vcvtsi2sd	xmm2, xmm3, edx
	vcvtsi2sd	xmm3, xmm3, dword ptr [rip + yres]
	vdivsd	xmm2, xmm2, xmm3
	vaddsd	xmm2, xmm2, qword ptr [rip + .LCPI10_2]
	vxorpd	xmm3, xmm2, xmmword ptr [rip + .LCPI10_3]
	vmovsd	xmm2, qword ptr [rip + aspect] # xmm2 = mem[0],zero
	vdivsd	xmm3, xmm3, xmm2
	vmovsd	qword ptr [rdi + 8], xmm3
	test	ecx, ecx
	je	.LBB10_4
# %bb.3:
	lea	r8d, [rsi + 4*rdx]
	mov	eax, esi
	add	eax, ecx
	and	eax, 1023
	add	r8d, dword ptr [4*rax + irand]
	and	r8d, 1023
	lea	rax, [r8 + 2*r8]
	lea	esi, [rdx + 4*rsi]
	add	ecx, edx
	and	ecx, 1023
	add	esi, dword ptr [4*rcx + irand]
	and	esi, 1023
	lea	rcx, [rsi + 2*rsi]
	vmulsd	xmm4, xmm0, qword ptr [8*rax + urand]
	vaddsd	xmm1, xmm1, xmm4
	vmulsd	xmm0, xmm0, qword ptr [8*rcx + urand+8]
	vmovsd	qword ptr [rdi], xmm1
	vdivsd	xmm0, xmm0, xmm2
	vaddsd	xmm0, xmm3, xmm0
	vmovsd	qword ptr [rdi + 8], xmm0
.LBB10_4:
	mov	rax, rdi
	ret
.Lfunc_end10:
	.size	get_sample_pos, .Lfunc_end10-get_sample_pos
	.cfi_endproc
                                        # -- End function
	.globl	jitter                  # -- Begin function jitter
	.p2align	4, 0x90
	.type	jitter,@function
jitter:                                 # @jitter
	.cfi_startproc
# %bb.0:
                                        # kill: def $ecx killed $ecx def $rcx
                                        # kill: def $edx killed $edx def $rdx
                                        # kill: def $esi killed $esi def $rsi
	lea	r8d, [rsi + 4*rdx]
	mov	eax, esi
	add	eax, ecx
	and	eax, 1023
	add	r8d, dword ptr [4*rax + irand]
	and	r8d, 1023
	lea	rax, [r8 + 2*r8]
	mov	rax, qword ptr [8*rax + urand]
	mov	qword ptr [rdi], rax
	lea	eax, [rdx + 4*rsi]
	add	ecx, edx
	and	ecx, 1023
	add	eax, dword ptr [4*rcx + irand]
	and	eax, 1023
	lea	rax, [rax + 2*rax]
	mov	rax, qword ptr [8*rax + urand+8]
	mov	qword ptr [rdi + 8], rax
	mov	rax, rdi
	ret
.Lfunc_end11:
	.size	jitter, .Lfunc_end11-jitter
	.cfi_endproc
                                        # -- End function
	.type	xres,@object            # @xres
	.data
	.globl	xres
	.p2align	2
xres:
	.long	800                     # 0x320
	.size	xres, 4

	.type	yres,@object            # @yres
	.globl	yres
	.p2align	2
yres:
	.long	600                     # 0x258
	.size	yres, 4

	.type	aspect,@object          # @aspect
	.globl	aspect
	.p2align	3
aspect:
	.quad	4608683617174607698     # double 1.3333330000000001
	.size	aspect, 8

	.type	lnum,@object            # @lnum
	.bss
	.globl	lnum
	.p2align	2
lnum:
	.long	0                       # 0x0
	.size	lnum, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Usage: c-ray-f [options]\n  Reads a scene file from stdin, writes the image to stdout, and stats to stderr.\n\nOptions:\n  -s WxH     where W is the width and H the height of the image\n  -r <rays>  shoot <rays> rays per pixel (antialiasing)\n  -i <file>  read from <file> instead of stdin\n  -o <file>  write to <file> instead of stdout\n  -h         this help screen\n\n"
	.size	.L.str, 363

	.type	usage,@object           # @usage
	.data
	.globl	usage
	.p2align	3
usage:
	.quad	.L.str
	.size	usage, 8

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"scene"
	.size	.L.str.1, 6

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"r"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"rendered_scene"
	.size	.L.str.3, 15

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"w"
	.size	.L.str.4, 2

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"pixel buffer allocation failed"
	.size	.L.str.5, 31

	.type	urand,@object           # @urand
	.comm	urand,24576,16
	.type	irand,@object           # @irand
	.comm	irand,4096,16
	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"Rendering took: %lu seconds (%lu milliseconds)\n"
	.size	.L.str.6, 48

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"P6\n%d %d\n255\n"
	.size	.L.str.7, 14

	.type	obj_list,@object        # @obj_list
	.comm	obj_list,8,8
	.type	lights,@object          # @lights
	.comm	lights,384,16
	.type	cam,@object             # @cam
	.comm	cam,56,8
	.type	get_sample_pos.sf,@object # @get_sample_pos.sf
	.local	get_sample_pos.sf
	.comm	get_sample_pos.sf,8,8
	.type	.L.str.8,@object        # @.str.8
.L.str.8:
	.asciz	" \t\n"
	.size	.L.str.8, 4

	.type	.L.str.9,@object        # @.str.9
.L.str.9:
	.asciz	"unknown type: %c\n"
	.size	.L.str.9, 18

	.type	get_msec.timeval,@object # @get_msec.timeval
	.local	get_msec.timeval
	.comm	get_msec.timeval,16,8
	.type	get_msec.first_timeval,@object # @get_msec.first_timeval
	.local	get_msec.first_timeval
	.comm	get_msec.first_timeval,16,8

	.ident	"clang version 7.0.0-3~ubuntu0.18.04.1 (tags/RELEASE_700/final)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym get_msec.timeval
