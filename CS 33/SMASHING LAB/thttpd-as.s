	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LASANPC4:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata
	.align 32
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LASANPC35:
.LFB35:
	.cfi_startproc
	subl	$28, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	jle	.L3
	movl	%eax, 12(%esp)
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	movl	stats_bytes, %eax
	fildl	16(%esp)
	pushl	httpd_conn_count
	.cfi_def_cfa_offset 40
	fildl	stats_bytes
	subl	$8, %esp
	.cfi_def_cfa_offset 48
	cltd
	fdiv	%st(1), %st
	fstpl	(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	stats_simultaneous
	.cfi_def_cfa_offset 60
	fildl	stats_connections
	subl	$8, %esp
	.cfi_def_cfa_offset 68
	fdivp	%st, %st(1)
	fstpl	(%esp)
	pushl	stats_connections
	.cfi_def_cfa_offset 72
	pushl	$.LC0
	.cfi_def_cfa_offset 76
	pushl	$6
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$48, %esp
	.cfi_def_cfa_offset 32
.L3:
	movl	$0, stats_connections
	movl	$0, stats_bytes
	movl	$0, stats_simultaneous
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata
	.align 32
.LC2:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC3:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC4:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LASANPC25:
.LFB25:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	xorl	%ebp, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$44, %esp
	.cfi_def_cfa_offset 64
	movl	numthrottles, %eax
	testl	%eax, %eax
	jg	.L114
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L169:
	leal	(%eax,%eax), %esi
	cmpl	%esi, 8(%esp)
	movl	%ecx, %esi
	jle	.L16
	shrl	$3, %esi
	movzbl	536870912(%esi), %edx
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jl	.L17
	testb	%dl, %dl
	jne	.L160
.L17:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	16(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	20(%esp)
	.cfi_def_cfa_offset 80
	pushl	(%ecx)
	.cfi_def_cfa_offset 84
	pushl	%ebp
	.cfi_def_cfa_offset 88
	pushl	$.LC2
	.cfi_def_cfa_offset 92
	pushl	$5
	.cfi_def_cfa_offset 96
	call	syslog
	addl	throttles, %edi
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	leal	12(%edi), %edx
	movl	%edi, %ecx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L20
	testb	%bl, %bl
	jne	.L161
.L20:
	movl	12(%ecx), %eax
	movl	%eax, 8(%esp)
.L13:
	leal	8(%ecx), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %esi
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movl	%esi, %edx
	cmpb	%dl, %al
	jl	.L21
	testb	%dl, %dl
	jne	.L162
.L21:
	movl	8(%ecx), %eax
	cmpl	8(%esp), %eax
	jle	.L22
	leal	20(%ecx), %esi
	movl	%esi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %edi
	movl	%esi, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	movl	%edi, %edx
	cmpb	%dl, %bl
	jl	.L23
	testb	%dl, %dl
	jne	.L163
.L23:
	movl	20(%ecx), %edi
	testl	%edi, %edi
	movl	%edi, 12(%esp)
	jne	.L164
.L22:
	addl	$1, %ebp
	cmpl	%ebp, numthrottles
	jle	.L26
.L114:
	leal	0(%ebp,%ebp,2), %eax
	movl	throttles, %ecx
	leal	0(,%eax,8), %edi
	addl	%edi, %ecx
	leal	12(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L10
	testb	%bl, %bl
	jne	.L165
.L10:
	leal	16(%ecx), %esi
	movl	12(%ecx), %eax
	movl	%esi, %edx
	shrl	$3, %edx
	addl	%eax, %eax
	movzbl	536870912(%edx), %ebx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L11
	testb	%bl, %bl
	jne	.L166
.L11:
	movl	16(%ecx), %edx
	leal	4(%ecx), %esi
	movl	$0, 16(%ecx)
	movl	%edx, %ebx
	shrl	$31, %ebx
	addl	%edx, %ebx
	sarl	%ebx
	addl	%eax, %ebx
	movl	$1431655766, %eax
	imull	%ebx
	movl	%esi, %eax
	sarl	$31, %ebx
	shrl	$3, %eax
	subl	%ebx, %edx
	movzbl	536870912(%eax), %ebx
	movl	%esi, %eax
	andl	$7, %eax
	movl	%edx, 8(%esp)
	movl	%edx, 12(%ecx)
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L12
	testb	%bl, %bl
	jne	.L167
.L12:
	movl	4(%ecx), %eax
	cmpl	%eax, 8(%esp)
	jle	.L13
	leal	20(%ecx), %esi
	movl	%esi, %ebx
	movl	%esi, %edx
	movl	%esi, 12(%esp)
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %esi
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	movl	%esi, %edx
	cmpb	%dl, %bl
	jl	.L14
	testb	%dl, %dl
	jne	.L168
.L14:
	movl	20(%ecx), %esi
	testl	%esi, %esi
	movl	%esi, 12(%esp)
	jne	.L169
	addl	$8, %ecx
	movl	%ecx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ecx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L22
	testb	%dl, %dl
	je	.L22
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L164:
	.cfi_restore_state
	movl	%ecx, %esi
	shrl	$3, %esi
	movzbl	536870912(%esi), %edi
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	movl	%edi, %ebx
	cmpb	%bl, %dl
	jl	.L24
	testb	%bl, %bl
	jne	.L170
.L24:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	16(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	20(%esp)
	.cfi_def_cfa_offset 80
	pushl	(%ecx)
	.cfi_def_cfa_offset 84
	pushl	%ebp
	.cfi_def_cfa_offset 88
	pushl	$.LC4
	.cfi_def_cfa_offset 92
	addl	$1, %ebp
	pushl	$5
	.cfi_def_cfa_offset 96
	call	syslog
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	cmpl	%ebp, numthrottles
	jg	.L114
	.p2align 4,,10
	.p2align 3
.L26:
	movl	max_connects, %eax
	movl	connects, %edi
	movl	$0, 16(%esp)
	testl	%eax, %eax
	movl	%eax, 28(%esp)
	leal	56(%edi), %ebx
	jg	.L113
	jmp	.L6
	.p2align 4,,10
	.p2align 3
.L32:
	addl	$1, 16(%esp)
	addl	$96, %ebx
	movl	16(%esp), %eax
	cmpl	28(%esp), %eax
	je	.L6
.L113:
	leal	-56(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L27
	testb	%cl, %cl
	jne	.L171
.L27:
	movl	-56(%ebx), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L32
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L30
	testb	%dl, %dl
	jne	.L172
.L30:
	leal	-4(%ebx), %edx
	movl	$-1, (%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L31
	testb	%cl, %cl
	jne	.L173
.L31:
	movl	-4(%ebx), %eax
	testl	%eax, %eax
	movl	%eax, 20(%esp)
	jle	.L32
	movl	throttles, %eax
	leal	-44(%ebx), %esi
	movl	$-1, %edi
	movl	$0, 8(%esp)
	movl	%ebx, 12(%esp)
	movl	%eax, 24(%esp)
	jmp	.L38
	.p2align 4,,10
	.p2align 3
.L177:
	movl	12(%esp), %eax
	movl	(%eax), %edi
.L38:
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L33
	testb	%dl, %dl
	jne	.L174
.L33:
	movl	(%esi), %eax
	movl	24(%esp), %edx
	leal	(%eax,%eax,2), %eax
	leal	(%edx,%eax,8), %eax
	leal	4(%eax), %ebp
	movl	%eax, %edx
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L34
	testb	%cl, %cl
	jne	.L175
.L34:
	leal	20(%edx), %ebp
	movl	4(%edx), %eax
	movl	%ebp, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%ebp, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L35
	testb	%bl, %bl
	jne	.L176
.L35:
	movl	%edx, %ecx
	cltd
	idivl	20(%ecx)
	cmpl	$-1, %edi
	je	.L159
	cmpl	%edi, %eax
	cmovg	%edi, %eax
.L159:
	movl	12(%esp), %edi
	addl	$1, 8(%esp)
	addl	$4, %esi
	movl	%eax, (%edi)
	movl	8(%esp), %eax
	cmpl	20(%esp), %eax
	jne	.L177
	movl	12(%esp), %ebx
	jmp	.L32
	.p2align 4,,10
	.p2align 3
.L16:
	shrl	$3, %esi
	movzbl	536870912(%esi), %edx
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jl	.L19
	testb	%dl, %dl
	jne	.L178
.L19:
	subl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 68
	pushl	16(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	20(%esp)
	.cfi_def_cfa_offset 80
	pushl	(%ecx)
	.cfi_def_cfa_offset 84
	pushl	%ebp
	.cfi_def_cfa_offset 88
	pushl	$.LC3
	.cfi_def_cfa_offset 92
	pushl	$6
	.cfi_def_cfa_offset 96
	call	syslog
	addl	throttles, %edi
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	leal	12(%edi), %edx
	movl	%edi, %ecx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L20
	testb	%bl, %bl
	je	.L20
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L6:
	.cfi_restore_state
	addl	$44, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L165:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L176:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L175:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L174:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L173:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L172:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L171:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L178:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L170:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L163:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L162:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L161:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L160:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L168:
	.cfi_restore_state
	movl	12(%esp), %edi
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L167:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L166:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata
	.align 32
.LC5:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LASANPC14:
.LFB14:
	.cfi_startproc
	testl	%edx, %edx
	jne	.L191
	rep ret
.L191:
	movl	$stderr, %edx
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	movl	%edx, %ecx
	andl	$7, %edx
	shrl	$3, %ecx
	subl	$8, %esp
	.cfi_def_cfa_offset 16
	addl	$3, %edx
	movzbl	536870912(%ecx), %ecx
	movl	argv0, %ebx
	cmpb	%cl, %dl
	jl	.L181
	testb	%cl, %cl
	jne	.L192
.L181:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	pushl	%ebx
	.cfi_def_cfa_offset 24
	pushl	$.LC5
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L192:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 32
.LC6:
	.string	"%s: value required for %s option\n"
	.zero	62
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LASANPC13:
.LFB13:
	.cfi_startproc
	testl	%edx, %edx
	je	.L205
	rep ret
.L205:
	movl	$stderr, %edx
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	movl	%edx, %ecx
	andl	$7, %edx
	shrl	$3, %ecx
	subl	$8, %esp
	.cfi_def_cfa_offset 16
	addl	$3, %edx
	movzbl	536870912(%ecx), %ecx
	movl	argv0, %ebx
	cmpb	%cl, %dl
	jl	.L195
	testb	%cl, %cl
	jne	.L206
.L195:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	pushl	%ebx
	.cfi_def_cfa_offset 24
	pushl	$.LC6
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L206:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata
	.align 32
.LC7:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.section	.text.unlikely,"ax",@progbits
	.type	usage, @function
usage:
.LASANPC11:
.LFB11:
	.cfi_startproc
	movl	$stderr, %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movb	536870912(%edx), %dl
	cmpb	%dl, %al
	jl	.L208
	testb	%dl, %dl
	je	.L208
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L208:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%ecx
	.cfi_def_cfa_offset 24
	pushl	$.LC7
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LASANPC30:
.LFB30:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leal	16(%esp), %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	leal	16(%esp), %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L217
	testb	%dl, %dl
	jne	.L254
.L217:
	movl	16(%esp), %eax
	leal	72(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L218
	testb	%bl, %bl
	jne	.L255
.L218:
	movl	%eax, %edx
	movl	$0, 72(%eax)
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L219
	testb	%cl, %cl
	jne	.L256
.L219:
	cmpl	$3, (%eax)
	je	.L257
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L257:
	.cfi_restore_state
	leal	8(%eax), %ecx
	movl	$2, (%eax)
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L221
	testb	%bl, %bl
	jne	.L258
.L221:
	movl	8(%eax), %edi
	leal	448(%edi), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %esi
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%esi, %ebx
	cmpb	%bl, %dl
	jl	.L222
	testb	%bl, %bl
	jne	.L259
.L222:
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	$1
	.cfi_def_cfa_offset 24
	pushl	%eax
	.cfi_def_cfa_offset 28
	pushl	448(%edi)
	.cfi_def_cfa_offset 32
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
.L256:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L255:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ecx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L254:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	leal	28(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L259:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ecx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L258:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%ecx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.globl	__asan_stack_malloc_1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC8:
	.string	"1 32 8 2 tv "
	.section	.rodata
	.align 32
.LC9:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LASANPC34:
.LFB34:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	subl	$108, %esp
	.cfi_def_cfa_offset 128
	movl	__asan_option_detect_stack_use_after_return, %eax
	movl	%esp, %esi
	movl	%esp, %ebp
	testl	%eax, %eax
	jne	.L274
.L260:
	movl	%esi, %edi
	movl	$1102416563, (%esi)
	movl	$.LC8, 4(%esi)
	shrl	$3, %edi
	testl	%ebx, %ebx
	movl	$.LASANPC34, 8(%esi)
	movl	$-235802127, 536870912(%edi)
	movl	$-185273344, 536870916(%edi)
	movl	$-202116109, 536870920(%edi)
	je	.L275
.L264:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L265
	testb	%dl, %dl
	jne	.L276
.L265:
	movl	(%ebx), %eax
	movl	$1, %ecx
	movl	%eax, %edx
	movl	%eax, %ebx
	subl	start_time, %edx
	subl	stats_time, %ebx
	movl	%eax, stats_time
	cmove	%ecx, %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 132
	pushl	%edx
	.cfi_def_cfa_offset 136
	pushl	$.LC9
	.cfi_def_cfa_offset 140
	pushl	$6
	.cfi_def_cfa_offset 144
	call	syslog
	movl	%ebx, %eax
	call	thttpd_logstats
	movl	%ebx, (%esp)
	call	httpd_logstats
	movl	%ebx, (%esp)
	call	mmc_logstats
	movl	%ebx, (%esp)
	call	fdwatch_logstats
	movl	%ebx, (%esp)
	call	tmr_logstats
	addl	$16, %esp
	.cfi_def_cfa_offset 128
	cmpl	%esi, %ebp
	jne	.L277
	movl	$0, 536870912(%edi)
	movl	$0, 536870916(%edi)
	movl	$0, 536870920(%edi)
.L262:
	addl	$108, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L275:
	.cfi_restore_state
	leal	32(%esi), %ebx
	subl	$8, %esp
	.cfi_def_cfa_offset 136
	pushl	$0
	.cfi_def_cfa_offset 140
	pushl	%ebx
	.cfi_def_cfa_offset 144
	call	gettimeofday
	addl	$16, %esp
	.cfi_def_cfa_offset 128
	jmp	.L264
.L276:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 140
	pushl	%ebx
	.cfi_def_cfa_offset 144
	call	__asan_report_load4
.L274:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 140
	pushl	$96
	.cfi_def_cfa_offset 144
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 128
	testl	%eax, %eax
	cmovne	%eax, %esi
	jmp	.L260
.L277:
	movl	$1172321806, (%esi)
	movl	$-168430091, 536870912(%edi)
	movl	$-168430091, 536870916(%edi)
	movl	$-168430091, 536870920(%edi)
	jmp	.L262
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LASANPC33:
.LFB33:
	.cfi_startproc
	movl	8(%esp), %eax
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LASANPC6:
.LFB6:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	call	__errno_location
	movl	%eax, %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L280
	testb	%dl, %dl
	jne	.L295
.L280:
	xorl	%eax, %eax
	movl	(%ebx), %esi
	call	logstats
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L281
	testb	%dl, %dl
	jne	.L296
.L281:
	movl	%esi, (%ebx)
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
.L296:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L295:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LASANPC32:
.LFB32:
	.cfi_startproc
	subl	$24, %esp
	.cfi_def_cfa_offset 28
	pushl	32(%esp)
	.cfi_def_cfa_offset 32
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata
	.align 32
.LC10:
	.string	"/tmp"
	.zero	59
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LASANPC7:
.LFB7:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	call	__errno_location
	movl	%eax, %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L300
	testb	%dl, %dl
	jne	.L316
.L300:
	movl	watchdog_flag, %eax
	movl	(%ebx), %esi
	testl	%eax, %eax
	je	.L317
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	movl	$0, watchdog_flag
	pushl	$360
	.cfi_def_cfa_offset 32
	call	alarm
	movl	%ebx, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L302
	testb	%dl, %dl
	jne	.L318
.L302:
	movl	%esi, (%ebx)
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
.L318:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L316:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L317:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$.LC10
	.cfi_def_cfa_offset 32
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC11:
	.string	"1 32 4 6 status "
	.section	.rodata
	.align 32
.LC12:
	.string	"child wait - %m"
	.zero	48
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LASANPC3:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$124, %esp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return, %eax
	leal	16(%esp), %esi
	testl	%eax, %eax
	jne	.L369
.L319:
	movl	%esi, %ebp
	movl	$1102416563, (%esi)
	movl	$.LC11, 4(%esi)
	shrl	$3, %ebp
	movl	$.LASANPC3, 8(%esi)
	leal	96(%esi), %edi
	movl	$-235802127, 536870912(%ebp)
	movl	$-185273340, 536870916(%ebp)
	movl	$-202116109, 536870920(%ebp)
	call	__errno_location
	movl	%eax, %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L323
	testb	%dl, %dl
	jne	.L370
.L323:
	movl	(%ebx), %eax
	subl	$64, %edi
	movl	%eax, 12(%esp)
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 11(%esp)
	.p2align 4,,10
	.p2align 3
.L324:
	subl	$4, %esp
	.cfi_def_cfa_offset 148
	pushl	$1
	.cfi_def_cfa_offset 152
	pushl	%edi
	.cfi_def_cfa_offset 156
	pushl	$-1
	.cfi_def_cfa_offset 160
	call	waitpid
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%eax, %eax
	je	.L329
	js	.L371
	movl	hs, %eax
	testl	%eax, %eax
	je	.L324
	leal	20(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	movb	%dl, 10(%esp)
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	10(%esp), %dl
	jl	.L330
	cmpb	$0, 10(%esp)
	jne	.L372
.L330:
	movl	20(%eax), %edx
	movl	$0, %ecx
	subl	$1, %edx
	cmovs	%ecx, %edx
	movl	%edx, 20(%eax)
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L371:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	cmpb	%al, 11(%esp)
	jl	.L327
	testb	%al, %al
	jne	.L373
.L327:
	movl	(%ebx), %eax
	cmpl	$4, %eax
	je	.L324
	cmpl	$11, %eax
	je	.L324
	cmpl	$10, %eax
	je	.L329
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	pushl	$.LC12
	.cfi_def_cfa_offset 156
	pushl	$3
	.cfi_def_cfa_offset 160
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L329:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L333
	testb	%dl, %dl
	jne	.L374
.L333:
	movl	12(%esp), %eax
	movl	%eax, (%ebx)
	leal	16(%esp), %eax
	cmpl	%esi, %eax
	jne	.L375
	movl	$0, 536870912(%ebp)
	movl	$0, 536870916(%ebp)
	movl	$0, 536870920(%ebp)
.L321:
	addl	$124, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L369:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	$96
	.cfi_def_cfa_offset 160
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%eax, %eax
	cmovne	%eax, %esi
	jmp	.L319
.L375:
	movl	$1172321806, (%esi)
	movl	$-168430091, 536870912(%ebp)
	movl	$-168430091, 536870916(%ebp)
	movl	$-168430091, 536870920(%ebp)
	jmp	.L321
.L374:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	__asan_report_store4
.L372:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ecx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L373:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L370:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata
	.align 32
.LC13:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC14:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LASANPC15:
.LFB15:
	.cfi_startproc
	subl	$24, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	strdup
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	je	.L386
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
.L386:
	.cfi_restore_state
	pushl	%edx
	.cfi_def_cfa_offset 20
	pushl	%edx
	.cfi_def_cfa_offset 24
	pushl	$.LC13
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L378
	testb	%dl, %dl
	jne	.L387
.L378:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	pushl	%ecx
	.cfi_def_cfa_offset 24
	pushl	$.LC14
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L387:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.globl	__asan_stack_malloc_2
	.section	.rodata.str1.1
.LC15:
	.string	"1 32 100 4 line "
	.section	.rodata
	.align 32
.LC16:
	.string	"r"
	.zero	62
	.align 32
.LC17:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC18:
	.string	"debug"
	.zero	58
	.align 32
.LC19:
	.string	"port"
	.zero	59
	.align 32
.LC20:
	.string	"dir"
	.zero	60
	.align 32
.LC21:
	.string	"chroot"
	.zero	57
	.align 32
.LC22:
	.string	"nochroot"
	.zero	55
	.align 32
.LC23:
	.string	"data_dir"
	.zero	55
	.align 32
.LC24:
	.string	"symlink"
	.zero	56
	.align 32
.LC25:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC26:
	.string	"symlinks"
	.zero	55
	.align 32
.LC27:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC28:
	.string	"user"
	.zero	59
	.align 32
.LC29:
	.string	"cgipat"
	.zero	57
	.align 32
.LC30:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC31:
	.string	"urlpat"
	.zero	57
	.align 32
.LC32:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC33:
	.string	"localpat"
	.zero	55
	.align 32
.LC34:
	.string	"throttles"
	.zero	54
	.align 32
.LC35:
	.string	"host"
	.zero	59
	.align 32
.LC36:
	.string	"logfile"
	.zero	56
	.align 32
.LC37:
	.string	"vhost"
	.zero	58
	.align 32
.LC38:
	.string	"novhost"
	.zero	56
	.align 32
.LC39:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC40:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC41:
	.string	"pidfile"
	.zero	56
	.align 32
.LC42:
	.string	"charset"
	.zero	56
	.align 32
.LC43:
	.string	"p3p"
	.zero	60
	.align 32
.LC44:
	.string	"max_age"
	.zero	56
	.align 32
.LC45:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LASANPC12:
.LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	subl	$220, %esp
	.cfi_def_cfa_offset 240
	leal	16(%esp), %eax
	movl	%eax, (%esp)
	movl	__asan_option_detect_stack_use_after_return, %eax
	testl	%eax, %eax
	jne	.L499
.L388:
	movl	(%esp), %edi
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	movl	%edi, %eax
	movl	$1102416563, (%edi)
	movl	$.LC15, 4(%edi)
	shrl	$3, %eax
	movl	$.LASANPC12, 8(%edi)
	movl	%eax, 20(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185273340, 536870928(%eax)
	movl	$-202116109, 536870932(%eax)
	pushl	$.LC16
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	fopen
	movl	%eax, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L494
	movl	%edi, %eax
	movl	$8388627, %esi
	addl	$32, %eax
	movl	%eax, 4(%esp)
.L392:
	subl	$4, %esp
	.cfi_def_cfa_offset 244
	pushl	12(%esp)
	.cfi_def_cfa_offset 248
	pushl	$1000
	.cfi_def_cfa_offset 252
	pushl	16(%esp)
	.cfi_def_cfa_offset 256
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L500
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$35
	.cfi_def_cfa_offset 252
	pushl	16(%esp)
	.cfi_def_cfa_offset 256
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L393
	movl	%eax, %edx
	movl	%eax, %ecx
	shrl	$3, %edx
	andl	$7, %ecx
	movzbl	536870912(%edx), %edx
	cmpb	%cl, %dl
	jg	.L394
	testb	%dl, %dl
	jne	.L501
.L394:
	movb	$0, (%eax)
.L393:
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC17
	.cfi_def_cfa_offset 252
	movl	16(%esp), %edi
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strspn
	addl	%eax, %edi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%edi, %eax
	movl	%edi, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L395
	testb	%al, %al
	jne	.L502
	.p2align 4,,10
	.p2align 3
.L395:
	cmpb	$0, (%edi)
	je	.L392
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC17
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcspn
	leal	(%edi,%eax), %ebx
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%ebx, %eax
	movl	%ebx, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L397
	testb	%al, %al
	jne	.L503
.L397:
	movzbl	(%ebx), %eax
	subl	$9, %eax
	cmpb	$23, %al
	ja	.L398
	btl	%eax, %esi
	jnc	.L398
	movl	%ebx, %eax
	.p2align 4,,10
	.p2align 3
.L401:
	movl	%eax, %edx
	movl	%eax, %ecx
	addl	$1, %ebx
	shrl	$3, %edx
	andl	$7, %ecx
	movzbl	536870912(%edx), %edx
	cmpb	%cl, %dl
	jg	.L399
	testb	%dl, %dl
	jne	.L504
.L399:
	movl	%ebx, %eax
	movb	$0, -1(%ebx)
	movl	%ebx, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L400
	testb	%al, %al
	jne	.L505
.L400:
	movzbl	(%ebx), %eax
	leal	-9(%eax), %edx
	cmpb	$23, %dl
	jbe	.L506
.L398:
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$61
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L437
	movl	%eax, %edx
	movl	%eax, %ecx
	leal	1(%eax), %ebp
	shrl	$3, %edx
	andl	$7, %ecx
	movzbl	536870912(%edx), %edx
	cmpb	%cl, %dl
	jg	.L403
	testb	%dl, %dl
	jne	.L507
.L403:
	movb	$0, (%eax)
.L402:
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC18
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L508
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC19
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L509
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC20
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L510
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC21
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L511
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC22
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L512
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC23
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L513
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC24
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L497
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC25
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L498
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC26
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L497
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC27
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L498
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC28
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L514
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC29
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L515
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC30
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L516
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC31
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L517
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC32
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L518
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC33
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L519
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC34
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L520
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC35
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L521
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC36
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L522
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC37
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L523
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC38
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L524
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC39
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L525
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC40
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L526
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC41
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L527
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC42
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L528
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC43
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L529
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC44
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	jne	.L431
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%ebp
	.cfi_def_cfa_offset 256
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%eax, max_age
	.p2align 4,,10
	.p2align 3
.L405:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 248
	pushl	$.LC17
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	strspn
	leal	(%ebx,%eax), %edi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%edi, %eax
	movl	%edi, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L395
	testb	%al, %al
	je	.L395
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L506:
	.cfi_restore_state
	btl	%edx, %esi
	movl	%ebx, %eax
	jc	.L401
	jmp	.L398
.L508:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$1, debug
	jmp	.L405
.L509:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%ebp
	.cfi_def_cfa_offset 256
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movw	%ax, port
	jmp	.L405
.L437:
	xorl	%ebp, %ebp
	jmp	.L402
.L510:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, dir
	jmp	.L405
.L511:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L405
.L512:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L405
.L497:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L405
.L513:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, data_dir
	jmp	.L405
.L498:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L405
.L514:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, user
	jmp	.L405
.L515:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, cgi_pattern
	jmp	.L405
.L516:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%ebp
	.cfi_def_cfa_offset 256
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%eax, cgi_limit
	jmp	.L405
.L517:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, url_pattern
	jmp	.L405
.L519:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, local_pattern
	jmp	.L405
.L518:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$1, no_empty_referers
	jmp	.L405
.L500:
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	20(%esp)
	.cfi_def_cfa_offset 256
	call	fclose
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	leal	16(%esp), %eax
	cmpl	(%esp), %eax
	jne	.L530
	movl	12(%esp), %eax
	movl	$0, 536870912(%eax)
	movl	$0, 536870928(%eax)
	movl	$0, 536870932(%eax)
	addl	$220, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L505:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
.L521:
	.cfi_restore_state
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, hostname
	jmp	.L405
.L520:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, throttlefile
	jmp	.L405
.L507:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_store1
.L530:
	.cfi_restore_state
	movl	(%esp), %eax
	movl	$1172321806, (%eax)
	movl	12(%esp), %eax
	movl	$-168430091, 536870912(%eax)
	movl	$-168430091, 536870916(%eax)
	movl	$-168430091, 536870920(%eax)
	movl	$-168430091, 536870924(%eax)
	movl	$-168430091, 536870928(%eax)
	movl	$-168430091, 536870932(%eax)
	addl	$220, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L504:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_store1
.L494:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L499:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	$192
	.cfi_def_cfa_offset 256
	call	__asan_stack_malloc_2
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	cmove	(%esp), %eax
	movl	%eax, (%esp)
	jmp	.L388
.L501:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_store1
.L502:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%edi
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
.L503:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
.L431:
	.cfi_restore_state
	movl	$stderr, %eax
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L432
	testb	%dl, %dl
	jne	.L531
.L432:
	pushl	%edi
	.cfi_remember_state
	.cfi_def_cfa_offset 244
	pushl	%ecx
	.cfi_def_cfa_offset 248
	pushl	$.LC45
	.cfi_def_cfa_offset 252
	pushl	stderr
	.cfi_def_cfa_offset 256
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L531:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	$stderr
	.cfi_def_cfa_offset 256
	call	__asan_report_load4
.L529:
	.cfi_restore_state
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, p3p
	jmp	.L405
.L528:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, charset
	jmp	.L405
.L527:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, pidfile
	jmp	.L405
.L526:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$0, do_global_passwd
	jmp	.L405
.L525:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$1, do_global_passwd
	jmp	.L405
.L524:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$0, do_vhost
	jmp	.L405
.L523:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	no_value_required
	movl	$1, do_vhost
	jmp	.L405
.L522:
	movl	%ebp, %edx
	movl	%edi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, logfile
	jmp	.L405
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata
	.align 32
.LC46:
	.string	"nobody"
	.zero	57
	.align 32
.LC47:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC48:
	.string	""
	.zero	63
	.align 32
.LC49:
	.string	"-V"
	.zero	61
	.align 32
.LC50:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC51:
	.string	"-C"
	.zero	61
	.align 32
.LC52:
	.string	"-p"
	.zero	61
	.align 32
.LC53:
	.string	"-d"
	.zero	61
	.align 32
.LC54:
	.string	"-r"
	.zero	61
	.align 32
.LC55:
	.string	"-nor"
	.zero	59
	.align 32
.LC56:
	.string	"-dd"
	.zero	60
	.align 32
.LC57:
	.string	"-s"
	.zero	61
	.align 32
.LC58:
	.string	"-nos"
	.zero	59
	.align 32
.LC59:
	.string	"-u"
	.zero	61
	.align 32
.LC60:
	.string	"-c"
	.zero	61
	.align 32
.LC61:
	.string	"-t"
	.zero	61
	.align 32
.LC62:
	.string	"-h"
	.zero	61
	.align 32
.LC63:
	.string	"-l"
	.zero	61
	.align 32
.LC64:
	.string	"-v"
	.zero	61
	.align 32
.LC65:
	.string	"-nov"
	.zero	59
	.align 32
.LC66:
	.string	"-g"
	.zero	61
	.align 32
.LC67:
	.string	"-nog"
	.zero	59
	.align 32
.LC68:
	.string	"-i"
	.zero	61
	.align 32
.LC69:
	.string	"-T"
	.zero	61
	.align 32
.LC70:
	.string	"-P"
	.zero	61
	.align 32
.LC71:
	.string	"-M"
	.zero	61
	.align 32
.LC72:
	.string	"-D"
	.zero	61
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LASANPC10:
.LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	$80, %ecx
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %edi
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	cmpl	$1, %eax
	movl	$0, debug
	movw	%cx, port
	movl	$0, dir
	movl	$0, data_dir
	movl	$0, do_chroot
	movl	$0, no_log
	movl	$0, no_symlink_check
	movl	$0, do_vhost
	movl	$0, do_global_passwd
	movl	$0, cgi_pattern
	movl	$0, cgi_limit
	movl	$0, url_pattern
	movl	$0, no_empty_referers
	movl	$0, local_pattern
	movl	$0, throttlefile
	movl	$0, hostname
	movl	$0, logfile
	movl	$0, pidfile
	movl	$.LC46, user
	movl	$.LC47, charset
	movl	$.LC48, p3p
	movl	$-1, max_age
	jle	.L581
	movl	%edx, %ebp
	leal	4(%edx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L534
	testb	%cl, %cl
	jne	.L696
.L534:
	movl	4(%ebp), %ebx
	movl	%ebx, %eax
	movl	%ebx, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L535
	testb	%al, %al
	jne	.L697
.L535:
	cmpb	$45, (%ebx)
	jne	.L576
	movl	$1, %esi
	jmp	.L579
	.p2align 4,,10
	.p2align 3
.L703:
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jg	.L698
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC52
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L543
.L542:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC53
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L543
	leal	1(%esi), %eax
	cmpl	%eax, %edi
	jle	.L543
	leal	0(%ebp,%eax,4), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L545
	testb	%bl, %bl
	jne	.L699
.L545:
	movl	(%edx), %edx
	movl	%eax, %esi
	movl	%edx, dir
.L541:
	addl	$1, %esi
	cmpl	%esi, %edi
	jle	.L533
.L705:
	leal	0(%ebp,%esi,4), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L577
	testb	%cl, %cl
	jne	.L700
.L577:
	movl	(%eax), %ebx
	movl	%ebx, %eax
	movl	%ebx, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L578
	testb	%al, %al
	jne	.L701
.L578:
	cmpb	$45, (%ebx)
	jne	.L576
.L579:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC49
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L702
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC51
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L703
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC52
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L542
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jle	.L543
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L544
	testb	%bl, %bl
	jne	.L704
.L544:
	movl	%edx, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	(%eax)
	.cfi_def_cfa_offset 64
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	12(%esp), %edx
	movw	%ax, port
	movl	%edx, %esi
	addl	$1, %esi
	cmpl	%esi, %edi
	jg	.L705
.L533:
	cmpl	%esi, %edi
	jne	.L576
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L543:
	.cfi_restore_state
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC54
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L546
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L541
	.p2align 4,,10
	.p2align 3
.L546:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC55
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L547
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L541
	.p2align 4,,10
	.p2align 3
.L698:
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L540
	testb	%bl, %bl
	jne	.L706
.L540:
	movl	(%eax), %eax
	movl	%edx, 12(%esp)
	call	read_config
	movl	12(%esp), %edx
	movl	%edx, %esi
	jmp	.L541
	.p2align 4,,10
	.p2align 3
.L547:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC56
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L548
	leal	1(%esi), %eax
	cmpl	%eax, %edi
	jle	.L548
	leal	0(%ebp,%eax,4), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L549
	testb	%bl, %bl
	jne	.L707
.L549:
	movl	(%edx), %edx
	movl	%eax, %esi
	movl	%edx, data_dir
	jmp	.L541
	.p2align 4,,10
	.p2align 3
.L548:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC57
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L550
	movl	$0, no_symlink_check
	jmp	.L541
	.p2align 4,,10
	.p2align 3
.L550:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC58
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L708
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC59
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L552
	leal	1(%esi), %eax
	cmpl	%eax, %edi
	jle	.L552
	leal	0(%ebp,%eax,4), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L553
	testb	%bl, %bl
	jne	.L709
.L553:
	movl	(%edx), %edx
	movl	%eax, %esi
	movl	%edx, user
	jmp	.L541
.L708:
	movl	$1, no_symlink_check
	jmp	.L541
.L552:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC60
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L554
	leal	1(%esi), %eax
	cmpl	%eax, %edi
	jle	.L554
	leal	0(%ebp,%eax,4), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L555
	testb	%bl, %bl
	je	.L555
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L554:
	.cfi_restore_state
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC61
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L710
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC62
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L559
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jle	.L560
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L561
	testb	%bl, %bl
	je	.L561
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L710:
	.cfi_restore_state
	leal	1(%esi), %eax
	cmpl	%eax, %edi
	jle	.L557
	leal	0(%ebp,%eax,4), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L558
	testb	%bl, %bl
	je	.L558
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L555:
	.cfi_restore_state
	movl	(%edx), %edx
	movl	%eax, %esi
	movl	%edx, cgi_pattern
	jmp	.L541
.L558:
	movl	(%edx), %edx
	movl	%eax, %esi
	movl	%edx, throttlefile
	jmp	.L541
.L561:
	movl	(%eax), %eax
	movl	%edx, %esi
	movl	%eax, hostname
	jmp	.L541
.L557:
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	pushl	$.LC62
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L559
.L560:
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC64
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L563
	movl	$1, do_vhost
	jmp	.L541
.L559:
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC63
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L560
	leal	1(%esi), %eax
	cmpl	%eax, %edi
	jle	.L560
	leal	0(%ebp,%eax,4), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L562
	testb	%bl, %bl
	jne	.L711
.L562:
	movl	(%edx), %edx
	movl	%eax, %esi
	movl	%edx, logfile
	jmp	.L541
.L563:
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	pushl	$.LC65
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L712
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC66
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L565
	movl	$1, do_global_passwd
	jmp	.L541
.L712:
	movl	$0, do_vhost
	jmp	.L541
.L581:
	movl	$1, %esi
	jmp	.L533
.L565:
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC67
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L566
	movl	$0, do_global_passwd
	jmp	.L541
.L702:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$.LC50
	.cfi_def_cfa_offset 64
	call	puts
	call	__asan_handle_no_return
	movl	$0, (%esp)
	call	exit
.L566:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC68
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L713
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC69
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L570
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jle	.L568
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L571
	testb	%bl, %bl
	jne	.L714
.L571:
	movl	(%eax), %eax
	movl	%edx, %esi
	movl	%eax, charset
	jmp	.L541
.L713:
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jle	.L568
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L569
	testb	%bl, %bl
	jne	.L715
.L569:
	movl	(%eax), %eax
	movl	%edx, %esi
	movl	%eax, pidfile
	jmp	.L541
.L568:
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC70
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L573
.L572:
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC71
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L573
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jle	.L573
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L575
	testb	%bl, %bl
	jne	.L716
.L575:
	movl	%edx, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	(%eax)
	.cfi_def_cfa_offset 64
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	12(%esp), %edx
	movl	%eax, max_age
	movl	%edx, %esi
	jmp	.L541
.L573:
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC72
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L576
	movl	$1, debug
	jmp	.L541
.L570:
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC70
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L572
	leal	1(%esi), %edx
	cmpl	%edx, %edi
	jle	.L573
	leal	0(%ebp,%edx,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L574
	testb	%bl, %bl
	jne	.L717
.L574:
	movl	(%eax), %eax
	movl	%edx, %esi
	movl	%eax, p3p
	jmp	.L541
.L717:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L716:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L715:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L700:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L709:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L711:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L714:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L699:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L697:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load1
.L696:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L704:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L701:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load1
.L706:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L576:
	.cfi_restore_state
	call	__asan_handle_no_return
	call	usage
.L707:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.globl	__asan_stack_malloc_8
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC73:
	.string	"5 32 4 9 max_limit 96 4 9 min_limit 160 8 2 tv 224 5000 3 buf 5280 5000 7 pattern "
	.globl	__asan_stack_free_8
	.section	.rodata
	.align 32
.LC74:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC75:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.align 32
.LC76:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC77:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC78:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC79:
	.string	"|/"
	.zero	61
	.align 32
.LC80:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC81:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LASANPC17:
.LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$10380, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, 16(%esp)
	leal	32(%esp), %eax
	movl	%eax, 20(%esp)
	movl	__asan_option_detect_stack_use_after_return, %eax
	testl	%eax, %eax
	jne	.L845
.L718:
	movl	20(%esp), %eax
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	movl	$1102416563, (%eax)
	movl	$.LC73, 4(%eax)
	leal	10336(%eax), %ebp
	movl	$.LASANPC17, 8(%eax)
	shrl	$3, %eax
	movl	%eax, 36(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185273340, 536870916(%eax)
	movl	$-218959118, 536870920(%eax)
	movl	$-185273340, 536870924(%eax)
	movl	$-218959118, 536870928(%eax)
	movl	$-185273344, 536870932(%eax)
	movl	$-218959118, 536870936(%eax)
	movl	$-185273344, 536871564(%eax)
	movl	$-218959118, 536871568(%eax)
	movl	$-185273344, 536872196(%eax)
	movl	$-202116109, 536872200(%eax)
	pushl	$.LC16
	.cfi_def_cfa_offset 10412
	pushl	28(%esp)
	.cfi_def_cfa_offset 10416
	call	fopen
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	je	.L846
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	pushl	$0
	.cfi_def_cfa_offset 10412
	movl	32(%esp), %esi
	movl	%esi, %eax
	leal	224(%esi), %ebx
	addl	$160, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	gettimeofday
	movl	$stderr, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	shrl	$3, %eax
	movl	%eax, 24(%esp)
	.p2align 4,,10
	.p2align 3
.L725:
	subl	$4, %esp
	.cfi_def_cfa_offset 10404
	pushl	16(%esp)
	.cfi_def_cfa_offset 10408
	pushl	$5000
	.cfi_def_cfa_offset 10412
	pushl	%ebx
	.cfi_def_cfa_offset 10416
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	je	.L847
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	pushl	$35
	.cfi_def_cfa_offset 10412
	pushl	%ebx
	.cfi_def_cfa_offset 10416
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	je	.L726
	movl	%eax, %edx
	movl	%eax, %ecx
	shrl	$3, %edx
	andl	$7, %ecx
	movzbl	536870912(%edx), %edx
	cmpb	%cl, %dl
	jg	.L727
	testb	%dl, %dl
	jne	.L848
.L727:
	movb	$0, (%eax)
.L726:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	%ebx
	.cfi_def_cfa_offset 10416
	call	strlen
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	movl	%eax, %edi
	jle	.L728
	subl	$1, %eax
	leal	(%ebx,%eax), %edi
	movl	%edi, %ecx
	movl	%edi, %esi
	shrl	$3, %ecx
	andl	$7, %esi
	movzbl	536870912(%ecx), %ecx
	movl	%esi, %edx
	cmpb	%dl, %cl
	jg	.L729
	testb	%cl, %cl
	jne	.L849
.L729:
	movzbl	-10112(%eax,%ebp), %esi
	leal	-9(%esi), %edx
	cmpb	$23, %dl
	jbe	.L850
	.p2align 4,,10
	.p2align 3
.L730:
	leal	-10240(%ebp), %eax
	leal	-10304(%ebp), %edi
	leal	-5056(%ebp), %esi
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	pushl	%eax
	.cfi_def_cfa_offset 10420
	pushl	%esi
	.cfi_def_cfa_offset 10424
	pushl	$.LC75
	.cfi_def_cfa_offset 10428
	pushl	%ebx
	.cfi_def_cfa_offset 10432
	call	__isoc99_sscanf
	addl	$32, %esp
	.cfi_def_cfa_offset 10400
	cmpl	$3, %eax
	je	.L732
	pushl	%edi
	.cfi_def_cfa_offset 10404
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$.LC76
	.cfi_def_cfa_offset 10412
	pushl	%ebx
	.cfi_def_cfa_offset 10416
	call	__isoc99_sscanf
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	cmpl	$2, %eax
	jne	.L738
	movl	$0, -10240(%ebp)
	.p2align 4,,10
	.p2align 3
.L732:
	cmpb	$47, -5056(%ebp)
	jne	.L741
	jmp	.L851
	.p2align 4,,10
	.p2align 3
.L742:
	leal	2(%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	addl	$1, %eax
	pushl	%edx
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
.L741:
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	pushl	$.LC79
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	strstr
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	jne	.L742
	movl	numthrottles, %edx
	movl	maxthrottles, %eax
	cmpl	%eax, %edx
	jl	.L743
	testl	%eax, %eax
	jne	.L744
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	movl	$100, maxthrottles
	pushl	$2400
	.cfi_def_cfa_offset 10416
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, throttles
.L745:
	testl	%eax, %eax
	je	.L746
	movl	numthrottles, %edx
.L747:
	leal	(%edx,%edx,2), %edx
	leal	(%eax,%edx,8), %edi
	movl	%esi, %eax
	call	e_strdup
	movl	%edi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%edi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L749
	testb	%cl, %cl
	jne	.L852
.L749:
	movl	%eax, (%edi)
	movl	numthrottles, %eax
	movl	-10304(%ebp), %edi
	leal	(%eax,%eax,2), %edx
	movl	%eax, 8(%esp)
	movl	throttles, %eax
	leal	(%eax,%edx,8), %eax
	leal	4(%eax), %esi
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L750
	testb	%cl, %cl
	jne	.L853
.L750:
	leal	8(%eax), %esi
	movl	%edi, 4(%eax)
	movl	-10240(%ebp), %edi
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L751
	testb	%cl, %cl
	jne	.L854
.L751:
	leal	12(%eax), %esi
	movl	%edi, 8(%eax)
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L752
	testb	%cl, %cl
	jne	.L855
.L752:
	leal	16(%eax), %esi
	movl	$0, 12(%eax)
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L753
	testb	%cl, %cl
	jne	.L856
.L753:
	leal	20(%eax), %esi
	movl	$0, 16(%eax)
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L754
	testb	%cl, %cl
	jne	.L857
.L754:
	movl	$0, 20(%eax)
	movl	8(%esp), %eax
	addl	$1, %eax
	movl	%eax, numthrottles
	jmp	.L725
	.p2align 4,,10
	.p2align 3
.L850:
	movl	$8388627, %ecx
	addl	%ebx, %eax
	movl	$8388627, %esi
	btl	%edx, %ecx
	jnc	.L730
	movl	%ebx, 8(%esp)
	.p2align 4,,10
	.p2align 3
.L838:
	movl	%eax, %edx
	movl	%eax, %ecx
	movl	%eax, %edi
	shrl	$3, %edx
	andl	$7, %ecx
	subl	8(%esp), %edi
	movzbl	536870912(%edx), %edx
	cmpb	%cl, %dl
	jg	.L734
	testb	%dl, %dl
	jne	.L858
.L734:
	cmpl	8(%esp), %eax
	movb	$0, (%eax)
	je	.L841
	leal	-1(%eax), %edx
	movl	%edx, %ecx
	movl	%edx, %edi
	shrl	$3, %ecx
	andl	$7, %edi
	movzbl	536870912(%ecx), %ecx
	movl	%edi, %ebx
	cmpb	%bl, %cl
	jg	.L735
	testb	%cl, %cl
	jne	.L859
.L735:
	movzbl	-1(%eax), %ecx
	subl	$9, %ecx
	cmpb	$23, %cl
	jbe	.L860
.L842:
	movl	8(%esp), %ebx
	jmp	.L730
	.p2align 4,,10
	.p2align 3
.L860:
	btl	%ecx, %esi
	movl	%edx, %eax
	jc	.L838
	jmp	.L842
	.p2align 4,,10
	.p2align 3
.L841:
	movl	8(%esp), %ebx
.L728:
	testl	%edi, %edi
	je	.L725
	jmp	.L730
.L744:
	leal	(%eax,%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	leal	(%edx,%eax,4), %eax
	movl	%edx, maxthrottles
	sall	$3, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10412
	pushl	throttles
	.cfi_def_cfa_offset 10416
	call	realloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, throttles
	jmp	.L745
.L738:
	pushl	%ebx
	.cfi_def_cfa_offset 10404
	pushl	20(%esp)
	.cfi_def_cfa_offset 10408
	pushl	$.LC77
	.cfi_def_cfa_offset 10412
	pushl	$2
	.cfi_def_cfa_offset 10416
	call	syslog
	movl	40(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	argv0, %ecx
	movzbl	536870912(%eax), %edx
	movl	$stderr, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L739
	testb	%dl, %dl
	jne	.L861
.L739:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	%ebx
	.cfi_def_cfa_offset 10416
	pushl	32(%esp)
	.cfi_def_cfa_offset 10420
	pushl	%ecx
	.cfi_def_cfa_offset 10424
	pushl	$.LC78
	.cfi_def_cfa_offset 10428
	pushl	stderr
	.cfi_def_cfa_offset 10432
	call	fprintf
	addl	$32, %esp
	.cfi_def_cfa_offset 10400
	jmp	.L725
.L743:
	movl	throttles, %eax
	jmp	.L747
.L847:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	24(%esp)
	.cfi_def_cfa_offset 10416
	call	fclose
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	leal	32(%esp), %eax
	cmpl	20(%esp), %eax
	jne	.L862
	movl	28(%esp), %esi
	xorl	%edx, %edx
	leal	536870916(%esi), %ecx
	movl	%esi, %eax
	movl	$0, 536870912(%esi)
	addl	$536870912, %eax
	movl	$0, 536870936(%esi)
	andl	$-4, %ecx
	subl	%ecx, %eax
	addl	$28, %eax
	andl	$-4, %eax
.L721:
	movl	$0, (%ecx,%edx)
	addl	$4, %edx
	cmpl	%eax, %edx
	jb	.L721
	movl	28(%esp), %eax
	movl	$0, 536871564(%eax)
	movl	$0, 536871568(%eax)
	movl	$0, 536872196(%eax)
	movl	$0, 536872200(%eax)
.L720:
	addl	$10380, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L851:
	.cfi_restore_state
	leal	-5055(%ebp), %eax
	pushl	%edi
	.cfi_def_cfa_offset 10404
	pushl	%edi
	.cfi_def_cfa_offset 10408
	pushl	%eax
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	jmp	.L741
.L845:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	$10336
	.cfi_def_cfa_offset 10416
	call	__asan_stack_malloc_8
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	cmove	20(%esp), %eax
	movl	%eax, 20(%esp)
	jmp	.L718
.L862:
	movl	20(%esp), %eax
	movl	$1172321806, (%eax)
	pushl	%edx
	.cfi_def_cfa_offset 10404
	leal	36(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$10336
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	__asan_stack_free_8
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	jmp	.L720
.L861:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	$stderr
	.cfi_def_cfa_offset 10416
	call	__asan_report_load4
.L859:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%edx
	.cfi_def_cfa_offset 10416
	call	__asan_report_load1
.L858:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	__asan_report_store1
.L857:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L856:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L855:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L854:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L853:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L852:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L746:
	.cfi_restore_state
	pushl	%esi
	.cfi_def_cfa_offset 10404
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$.LC80
	.cfi_def_cfa_offset 10412
	pushl	$2
	.cfi_def_cfa_offset 10416
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L748
	testb	%dl, %dl
	jne	.L863
.L748:
	pushl	%ebx
	.cfi_remember_state
	.cfi_def_cfa_offset 10404
	pushl	%ecx
	.cfi_def_cfa_offset 10408
	pushl	$.LC81
	.cfi_def_cfa_offset 10412
	pushl	stderr
	.cfi_def_cfa_offset 10416
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L848:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	__asan_report_store1
.L846:
	.cfi_restore_state
	pushl	%ebp
	.cfi_remember_state
	.cfi_def_cfa_offset 10404
	movl	20(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$.LC74
	.cfi_def_cfa_offset 10412
	pushl	$2
	.cfi_def_cfa_offset 10416
	call	syslog
	movl	%esi, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L849:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	call	__asan_report_load1
.L863:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	$stderr
	.cfi_def_cfa_offset 10416
	call	__asan_report_load4
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata
	.align 32
.LC82:
	.string	"-"
	.zero	62
	.align 32
.LC83:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC84:
	.string	"a"
	.zero	62
	.align 32
.LC85:
	.string	"re-opening %.80s - %m"
	.zero	42
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LASANPC8:
.LFB8:
	.cfi_startproc
	movl	no_log, %eax
	testl	%eax, %eax
	jne	.L879
	movl	hs, %ecx
	testl	%ecx, %ecx
	je	.L879
	movl	logfile, %eax
	testl	%eax, %eax
	je	.L879
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	subl	$12, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC82
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	jne	.L880
.L864:
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
.L879:
	rep ret
	.p2align 4,,10
	.p2align 3
.L880:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -12
	.cfi_offset 6, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC83
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	popl	%ecx
	.cfi_def_cfa_offset 28
	popl	%ebx
	.cfi_def_cfa_offset 24
	pushl	$.LC84
	.cfi_def_cfa_offset 28
	pushl	logfile
	.cfi_def_cfa_offset 32
	call	fopen
	movl	logfile, %esi
	movl	%eax, %ebx
	popl	%eax
	.cfi_def_cfa_offset 28
	popl	%edx
	.cfi_def_cfa_offset 24
	pushl	$384
	.cfi_def_cfa_offset 28
	pushl	%esi
	.cfi_def_cfa_offset 32
	call	chmod
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%ebx, %ebx
	je	.L868
	testl	%eax, %eax
	jne	.L868
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	fileno
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	pushl	$1
	.cfi_def_cfa_offset 24
	pushl	$2
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	fcntl
	popl	%eax
	.cfi_def_cfa_offset 28
	popl	%edx
	.cfi_def_cfa_offset 24
	pushl	%ebx
	.cfi_def_cfa_offset 28
	pushl	hs
	.cfi_def_cfa_offset 32
	call	httpd_set_logfp
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	jmp	.L864
	.p2align 4,,10
	.p2align 3
.L868:
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	%esi
	.cfi_def_cfa_offset 24
	pushl	$.LC85
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	jmp	.L864
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
	.align 32
.LC86:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC87:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC88:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LASANPC19:
.LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	%edx, %ebp
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%edi, %edx
	andl	$7, %edx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	num_connects, %eax
	leal	3(%edx), %ecx
	movb	%cl, 8(%esp)
.L905:
	cmpl	%eax, max_connects
	jle	.L1006
	movl	first_free_connect, %eax
	cmpl	$-1, %eax
	je	.L884
	leal	(%eax,%eax,2), %ebx
	sall	$5, %ebx
	addl	connects, %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L885
	testb	%dl, %dl
	jne	.L1007
.L885:
	movl	(%ebx), %edx
	testl	%edx, %edx
	jne	.L884
	leal	8(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L887
	testb	%dl, %dl
	jne	.L1008
.L887:
	movl	8(%ebx), %eax
	testl	%eax, %eax
	je	.L1009
.L888:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	%ebp
	.cfi_def_cfa_offset 60
	pushl	hs
	.cfi_def_cfa_offset 64
	call	httpd_get_conn
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L892
	cmpl	$2, %eax
	je	.L907
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L893
	testb	%dl, %dl
	jne	.L1010
.L893:
	leal	4(%ebx), %edx
	movl	$1, (%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L894
	testb	%cl, %cl
	jne	.L1011
.L894:
	movl	4(%ebx), %eax
	addl	$1, num_connects
	movl	$-1, 4(%ebx)
	movl	%eax, first_free_connect
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	cmpb	%al, 8(%esp)
	jl	.L895
	testb	%al, %al
	jne	.L1012
.L895:
	movl	(%edi), %eax
	leal	68(%ebx), %edx
	movl	%eax, 12(%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L896
	testb	%cl, %cl
	jne	.L1013
.L896:
	movl	12(%esp), %eax
	leal	72(%ebx), %edx
	movl	%eax, 68(%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L897
	testb	%cl, %cl
	jne	.L1014
.L897:
	leal	76(%ebx), %edx
	movl	$0, 72(%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L898
	testb	%cl, %cl
	jne	.L1015
.L898:
	leal	92(%ebx), %edx
	movl	$0, 76(%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L899
	testb	%cl, %cl
	jne	.L1016
.L899:
	leal	52(%ebx), %edx
	movl	$0, 92(%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L900
	testb	%cl, %cl
	jne	.L1017
.L900:
	movl	%esi, %eax
	movl	$0, 52(%ebx)
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L901
	testb	%dl, %dl
	jne	.L1018
.L901:
	movl	8(%ebx), %ecx
	leal	448(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	movb	%al, 12(%esp)
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	12(%esp), %al
	jl	.L902
	cmpb	$0, 12(%esp)
	jne	.L1019
.L902:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	448(%ecx)
	.cfi_def_cfa_offset 64
	call	httpd_set_ndelay
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L903
	testb	%dl, %dl
	jne	.L1020
.L903:
	movl	8(%ebx), %eax
	leal	448(%eax), %edx
	movl	%eax, 12(%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %esi
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movl	%esi, %ecx
	cmpb	%cl, %al
	jl	.L904
	testb	%cl, %cl
	jne	.L1021
.L904:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	$0
	.cfi_def_cfa_offset 56
	pushl	%ebx
	.cfi_def_cfa_offset 60
	movl	24(%esp), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_add_fd
	addl	$1, stats_connections
	movl	num_connects, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	cmpl	stats_simultaneous, %eax
	jle	.L905
	movl	%eax, stats_simultaneous
	jmp	.L905
	.p2align 4,,10
	.p2align 3
.L907:
	movl	$1, %eax
.L881:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L892:
	.cfi_restore_state
	movl	%eax, 8(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	8(%esp), %eax
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1009:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	$456
	.cfi_def_cfa_offset 64
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	%eax, 8(%ebx)
	je	.L1022
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L890
	testb	%cl, %cl
	jne	.L1023
.L890:
	movl	$0, (%eax)
	addl	$1, httpd_conn_count
	jmp	.L888
.L1023:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L1006:
	.cfi_restore_state
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC86
	.cfi_def_cfa_offset 60
	pushl	$4
	.cfi_def_cfa_offset 64
	call	syslog
	movl	%edi, (%esp)
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	jmp	.L881
.L884:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC87
	.cfi_def_cfa_offset 60
.L1004:
	pushl	$2
	.cfi_def_cfa_offset 64
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L1022:
	.cfi_def_cfa_offset 48
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC88
	.cfi_def_cfa_offset 60
	jmp	.L1004
.L1014:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1007:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1011:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1012:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1013:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1008:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1015:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1016:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1017:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1018:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1019:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1020:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1021:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1010:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata
	.align 32
.LC89:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LASANPC23:
.LFB23:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	addl	$52, %eax
	movl	%eax, %edi
	subl	$60, %esp
	.cfi_def_cfa_offset 80
	movl	%eax, 12(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1025
	testb	%dl, %dl
	jne	.L1178
.L1025:
	leal	60(%ebp), %eax
	movl	$0, 52(%ebp)
	movl	%eax, %edi
	movl	%eax, 36(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1026
	testb	%dl, %dl
	jne	.L1179
.L1026:
	leal	56(%ebp), %eax
	movl	$-1, 60(%ebp)
	movl	%eax, %edi
	movl	%eax, 32(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1027
	testb	%dl, %dl
	jne	.L1180
.L1027:
	leal	8(%ebp), %eax
	xorl	%esi, %esi
	movl	$-1, 56(%ebp)
	movl	$0, 4(%esp)
	movl	%eax, %edi
	movl	%eax, 44(%esp)
	andl	$7, %eax
	addl	$3, %eax
	shrl	$3, %edi
	movb	%al, 30(%esp)
	movl	numthrottles, %eax
	movl	%edi, 16(%esp)
	movl	%esi, %edi
	testl	%eax, %eax
	jg	.L1134
	jmp	.L1051
	.p2align 4,,10
	.p2align 3
.L1050:
	movl	24(%esp), %esi
	cmpl	%esi, %eax
	cmovl	%esi, %eax
	movl	%eax, 60(%ebp)
.L1033:
	addl	$1, 4(%esp)
	movl	4(%esp), %eax
	cmpl	%eax, numthrottles
	jle	.L1051
	movl	12(%esp), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1052
	testb	%dl, %dl
	jne	.L1181
.L1052:
	addl	$24, %edi
	cmpl	$9, 52(%ebp)
	jg	.L1051
.L1134:
	movl	16(%esp), %eax
	movzbl	536870912(%eax), %eax
	cmpb	%al, 30(%esp)
	jl	.L1030
	testb	%al, %al
	jne	.L1182
.L1030:
	movl	8(%ebp), %ecx
	leal	188(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L1031
	testb	%bl, %bl
	jne	.L1183
.L1031:
	movl	throttles, %eax
	movl	188(%ecx), %ebx
	addl	%edi, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1032
	testb	%cl, %cl
	jne	.L1184
.L1032:
	subl	$8, %esp
	.cfi_def_cfa_offset 88
	pushl	%ebx
	.cfi_def_cfa_offset 92
	pushl	(%eax)
	.cfi_def_cfa_offset 96
	call	match
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	testl	%eax, %eax
	je	.L1033
	movl	throttles, %eax
	addl	%edi, %eax
	leal	12(%eax), %ecx
	movl	%eax, 8(%esp)
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L1034
	testb	%bl, %bl
	jne	.L1185
.L1034:
	movl	8(%esp), %eax
	leal	4(%eax), %ecx
	movl	12(%eax), %ebx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %esi
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%esi, %eax
	cmpb	%al, %dl
	jl	.L1035
	testb	%al, %al
	jne	.L1186
.L1035:
	movl	8(%esp), %esi
	movl	4(%esi), %eax
	leal	(%eax,%eax), %edx
	movl	%eax, 20(%esp)
	cmpl	%edx, %ebx
	jg	.L1055
	leal	8(%esi), %esi
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1036
	testb	%cl, %cl
	jne	.L1187
.L1036:
	movl	8(%esp), %esi
	movl	8(%esi), %eax
	cmpl	%eax, %ebx
	movl	%eax, 24(%esp)
	jl	.L1055
	leal	20(%esi), %esi
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1037
	testb	%cl, %cl
	jne	.L1188
.L1037:
	movl	8(%esp), %eax
	movl	20(%eax), %ecx
	testl	%ecx, %ecx
	js	.L1038
	addl	$1, %ecx
.L1039:
	movl	12(%esp), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L1043
	testb	%bl, %bl
	jne	.L1189
.L1043:
	movl	52(%ebp), %edx
	leal	12(%ebp,%edx,4), %eax
	leal	1(%edx), %ebx
	movl	%ebx, 52(%ebp)
	movl	%eax, %ebx
	movl	%eax, 40(%esp)
	shrl	$3, %ebx
	andl	$7, %eax
	movzbl	536870912(%ebx), %ebx
	movb	%bl, 31(%esp)
	movl	%eax, %ebx
	movzbl	31(%esp), %eax
	addl	$3, %ebx
	cmpb	%al, %bl
	jl	.L1044
	testb	%al, %al
	jne	.L1190
.L1044:
	movl	4(%esp), %eax
	movl	%eax, 12(%ebp,%edx,4)
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L1045
	testb	%bl, %bl
	jne	.L1191
.L1045:
	movl	8(%esp), %eax
	movl	32(%esp), %esi
	movl	%ecx, 20(%eax)
	movl	20(%esp), %eax
	cltd
	idivl	%ecx
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1046
	testb	%cl, %cl
	jne	.L1192
.L1046:
	movl	56(%ebp), %edx
	cmpl	$-1, %edx
	je	.L1177
	cmpl	%edx, %eax
	cmovg	%edx, %eax
.L1177:
	movl	36(%esp), %esi
	movl	%eax, 56(%ebp)
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1049
	testb	%dl, %dl
	jne	.L1193
.L1049:
	movl	60(%ebp), %eax
	cmpl	$-1, %eax
	jne	.L1050
	movl	24(%esp), %eax
	movl	%eax, 60(%ebp)
	jmp	.L1033
	.p2align 4,,10
	.p2align 3
.L1038:
	subl	$8, %esp
	.cfi_def_cfa_offset 88
	pushl	$.LC89
	.cfi_def_cfa_offset 92
	pushl	$3
	.cfi_def_cfa_offset 96
	call	syslog
	movl	throttles, %eax
	addl	%edi, %eax
	leal	20(%eax), %esi
	movl	%eax, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1040
	testb	%cl, %cl
	jne	.L1194
.L1040:
	movl	8(%esp), %eax
	leal	4(%eax), %ecx
	movl	$0, 20(%eax)
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L1041
	testb	%bl, %bl
	jne	.L1195
.L1041:
	movl	8(%esp), %ebx
	movl	4(%ebx), %eax
	leal	8(%ebx), %ebx
	movl	%ebx, %edx
	shrl	$3, %edx
	movl	%eax, 20(%esp)
	movzbl	536870912(%edx), %ecx
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1042
	testb	%cl, %cl
	jne	.L1196
.L1042:
	movl	8(%esp), %eax
	movl	$1, %ecx
	movl	8(%eax), %eax
	movl	%eax, 24(%esp)
	jmp	.L1039
	.p2align 4,,10
	.p2align 3
.L1051:
	addl	$60, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	movl	$1, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1055:
	.cfi_restore_state
	addl	$60, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	xorl	%eax, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1196:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%ebx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1195:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%ecx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1194:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%esi
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1181:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	24(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1187:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%esi
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1189:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	24(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1188:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%esi
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1193:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	48(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1192:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	44(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1191:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%esi
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1190:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	52(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1186:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%ecx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1185:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%ecx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1184:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%eax
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1183:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%edx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1182:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	56(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1180:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	44(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1179:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	48(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1178:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 92
	pushl	24(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LASANPC18:
.LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$124, %esp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return, %ebx
	leal	16(%esp), %edi
	testl	%ebx, %ebx
	jne	.L1276
.L1197:
	movl	%edi, %eax
	leal	32(%edi), %ebx
	movl	$1102416563, (%edi)
	shrl	$3, %eax
	movl	$.LC8, 4(%edi)
	movl	$.LASANPC18, 8(%edi)
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	movl	%eax, 16(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185273344, 536870916(%eax)
	movl	$-202116109, 536870920(%eax)
	xorl	%esi, %esi
	pushl	$0
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	gettimeofday
	movl	%ebx, %eax
	call	logstats
	movl	max_connects, %ecx
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%ecx, %ecx
	jle	.L1212
	movl	%edi, 12(%esp)
	movl	%ebx, %edi
	jmp	.L1254
	.p2align 4,,10
	.p2align 3
.L1205:
	leal	8(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebp
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%ebp, %ebx
	cmpb	%bl, %dl
	jl	.L1207
	testb	%bl, %bl
	jne	.L1277
.L1207:
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L1208
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	httpd_destroy_conn
	movl	20(%esp), %ebx
	addl	connects, %ebx
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	leal	8(%ebx), %ebp
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1209
	testb	%dl, %dl
	jne	.L1278
.L1209:
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	8(%ebx)
	.cfi_def_cfa_offset 160
	call	free
	movl	%ebp, %eax
	subl	$1, httpd_conn_count
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1210
	testb	%dl, %dl
	jne	.L1279
.L1210:
	movl	$0, 8(%ebx)
.L1208:
	addl	$1, %esi
	cmpl	%esi, max_connects
	jle	.L1280
.L1254:
	leal	(%esi,%esi,2), %ebx
	movl	connects, %eax
	sall	$5, %ebx
	addl	%ebx, %eax
	movl	%ebx, 4(%esp)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1204
	testb	%cl, %cl
	jne	.L1281
.L1204:
	movl	(%eax), %edx
	testl	%edx, %edx
	je	.L1205
	leal	8(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebp
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%ebp, %ebx
	cmpb	%bl, %dl
	jl	.L1206
	testb	%bl, %bl
	jne	.L1282
.L1206:
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	pushl	%edi
	.cfi_def_cfa_offset 156
	pushl	8(%eax)
	.cfi_def_cfa_offset 160
	call	httpd_close_conn
	movl	20(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	addl	connects, %eax
	jmp	.L1205
	.p2align 4,,10
	.p2align 3
.L1280:
	movl	12(%esp), %edi
.L1212:
	movl	hs, %ebx
	testl	%ebx, %ebx
	je	.L1203
	leal	40(%ebx), %edx
	movl	$0, hs
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1213
	testb	%cl, %cl
	jne	.L1283
.L1213:
	movl	40(%ebx), %eax
	cmpl	$-1, %eax
	je	.L1214
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1214:
	leal	44(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1215
	testb	%cl, %cl
	jne	.L1284
.L1215:
	movl	44(%ebx), %eax
	cmpl	$-1, %eax
	je	.L1216
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1216:
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	httpd_terminate
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1203:
	call	mmc_destroy
	call	tmr_destroy
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	connects
	.cfi_def_cfa_offset 160
	call	free
	movl	throttles, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%eax, %eax
	je	.L1200
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	free
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1200:
	leal	16(%esp), %eax
	cmpl	%edi, %eax
	jne	.L1285
	movl	8(%esp), %eax
	movl	$0, 536870912(%eax)
	movl	$0, 536870916(%eax)
	movl	$0, 536870920(%eax)
.L1199:
	addl	$124, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1284:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%edx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1283:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%edx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1282:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ecx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1279:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebp
	.cfi_def_cfa_offset 160
	call	__asan_report_store4
.L1278:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebp
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1277:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ecx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1281:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1276:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	$96
	.cfi_def_cfa_offset 160
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%eax, %eax
	cmovne	%eax, %edi
	jmp	.L1197
.L1285:
	movl	$1172321806, (%edi)
	movl	8(%esp), %eax
	movl	$-168430091, 536870912(%eax)
	movl	$-168430091, 536870916(%eax)
	movl	$-168430091, 536870920(%eax)
	jmp	.L1199
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata
	.align 32
.LC90:
	.string	"exiting"
	.zero	56
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LASANPC5:
.LFB5:
	.cfi_startproc
	movl	num_connects, %edx
	testl	%edx, %edx
	je	.L1291
	movl	$1, got_usr1
	ret
.L1291:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC90
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$0, (%esp)
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata
	.align 32
.LC91:
	.string	"exiting due to signal %d"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LASANPC2:
.LFB2:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	20(%esp)
	.cfi_def_cfa_offset 24
	pushl	$.LC91
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LASANPC36:
.LFB36:
	.cfi_startproc
	leal	52(%eax), %ecx
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%ecx, %edx
	shrl	$3, %edx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L1295
	testb	%bl, %bl
	jne	.L1322
.L1295:
	movl	52(%eax), %esi
	xorl	%ebx, %ebx
	addl	$12, %eax
	movl	throttles, %ebp
	testl	%esi, %esi
	movl	%esi, 12(%esp)
	jle	.L1294
	movl	%ebx, 8(%esp)
	.p2align 4,,10
	.p2align 3
.L1313:
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1297
	testb	%cl, %cl
	jne	.L1323
.L1297:
	movl	(%eax), %edx
	leal	(%edx,%edx,2), %edx
	leal	0(%ebp,%edx,8), %edx
	leal	20(%edx), %esi
	movl	%esi, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %edi
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%edi, %ebx
	cmpb	%bl, %cl
	jl	.L1298
	testb	%bl, %bl
	jne	.L1324
.L1298:
	addl	$1, 8(%esp)
	movl	12(%esp), %ebx
	addl	$4, %eax
	movl	8(%esp), %edi
	subl	$1, 20(%edx)
	cmpl	%ebx, %edi
	jne	.L1313
.L1294:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1322:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1324:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1323:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LASANPC28:
.LFB28:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%edx, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leal	8(%eax), %esi
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	movl	%esi, %eax
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1326
	testb	%dl, %dl
	jne	.L1395
.L1326:
	movl	8(%ebx), %eax
	leal	168(%eax), %ecx
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebp
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%ebp, %edx
	cmpb	%dl, %cl
	jl	.L1327
	testb	%dl, %dl
	jne	.L1396
.L1327:
	movl	168(%eax), %edx
	addl	%edx, stats_bytes
	movl	%ebx, %edx
	shrl	$3, %edx
	movl	%ebx, %ecx
	movzbl	536870912(%edx), %edx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L1328
	testb	%dl, %dl
	jne	.L1397
.L1328:
	cmpl	$3, (%ebx)
	je	.L1329
	leal	448(%eax), %ecx
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebp
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%ebp, %ecx
	cmpb	%cl, %dl
	jl	.L1330
	testb	%cl, %cl
	jne	.L1398
.L1330:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_del_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1331
	testb	%dl, %dl
	jne	.L1399
.L1331:
	movl	8(%ebx), %eax
.L1329:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	leal	76(%ebx), %esi
	pushl	%edi
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	httpd_close_conn
	movl	%ebx, %eax
	call	clear_throttles.isra.0
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1332
	testb	%dl, %dl
	jne	.L1400
.L1332:
	movl	76(%ebx), %eax
	testl	%eax, %eax
	je	.L1333
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	tmr_cancel
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1334
	testb	%dl, %dl
	jne	.L1401
.L1334:
	movl	$0, 76(%ebx)
.L1333:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1335
	testb	%dl, %dl
	jne	.L1402
.L1335:
	leal	4(%ebx), %edx
	movl	$0, (%ebx)
	movl	first_free_connect, %esi
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1336
	testb	%cl, %cl
	jne	.L1403
.L1336:
	movl	%esi, 4(%ebx)
	subl	connects, %ebx
	subl	$1, num_connects
	sarl	$5, %ebx
	imull	$-1431655765, %ebx, %ebx
	movl	%ebx, first_free_connect
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1400:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1397:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1396:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1395:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1403:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1402:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1401:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1399:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1398:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata
	.align 32
.LC92:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC93:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LASANPC27:
.LFB27:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%edx, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leal	72(%eax), %esi
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	movl	%esi, %eax
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1405
	testb	%dl, %dl
	jne	.L1537
.L1405:
	movl	72(%ebx), %eax
	testl	%eax, %eax
	je	.L1406
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	tmr_cancel
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1407
	testb	%dl, %dl
	jne	.L1538
.L1407:
	movl	$0, 72(%ebx)
.L1406:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1408
	testb	%dl, %dl
	jne	.L1539
.L1408:
	movl	(%ebx), %ecx
	cmpl	$4, %ecx
	je	.L1540
	leal	8(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1415
	testb	%dl, %dl
	jne	.L1541
.L1415:
	movl	8(%ebx), %eax
	leal	356(%eax), %edi
	movl	%eax, 8(%esp)
	movl	%edi, %edx
	movl	%edi, %eax
	shrl	$3, %edx
	andl	$7, %eax
	movzbl	536870912(%edx), %edx
	movb	%dl, 15(%esp)
	movl	%eax, %edx
	movzbl	15(%esp), %eax
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L1416
	testb	%al, %al
	jne	.L1542
.L1416:
	movl	8(%esp), %eax
	movl	356(%eax), %edi
	testl	%edi, %edi
	je	.L1414
	cmpl	$3, %ecx
	je	.L1417
	leal	448(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edi
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%edi, %eax
	cmpb	%al, %dl
	jl	.L1418
	testb	%al, %al
	jne	.L1543
.L1418:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	movl	20(%esp), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_del_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1419
	testb	%dl, %dl
	jne	.L1544
.L1419:
	movl	8(%ebx), %eax
	movl	%eax, 8(%esp)
.L1417:
	movl	%ebx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1420
	testb	%cl, %cl
	jne	.L1545
.L1420:
	movl	8(%esp), %eax
	movl	$4, (%ebx)
	leal	448(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edi
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	movl	%edi, %eax
	cmpb	%al, %dl
	jl	.L1421
	testb	%al, %al
	jne	.L1546
.L1421:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$1
	.cfi_def_cfa_offset 60
	movl	20(%esp), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	shutdown
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1422
	testb	%dl, %dl
	jne	.L1547
.L1422:
	movl	8(%ebx), %edi
	leal	448(%edi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %esi
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movl	%esi, %ecx
	cmpb	%cl, %al
	jl	.L1423
	testb	%cl, %cl
	jne	.L1548
.L1423:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	leal	76(%ebx), %esi
	pushl	$0
	.cfi_def_cfa_offset 56
	pushl	%ebx
	.cfi_def_cfa_offset 60
	pushl	448(%edi)
	.cfi_def_cfa_offset 64
	call	fdwatch_add_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1424
	testb	%dl, %dl
	jne	.L1549
.L1424:
	movl	76(%ebx), %edx
	testl	%edx, %edx
	je	.L1425
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC92
	.cfi_def_cfa_offset 60
	pushl	$3
	.cfi_def_cfa_offset 64
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 48
.L1425:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	$0
	.cfi_def_cfa_offset 64
	pushl	$500
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$linger_clear_connection
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	tmr_create
	movl	%esi, %edx
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1426
	testb	%cl, %cl
	jne	.L1550
.L1426:
	testl	%eax, %eax
	movl	%eax, 76(%ebx)
	je	.L1551
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1540:
	.cfi_restore_state
	leal	76(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1410
	testb	%dl, %dl
	jne	.L1552
.L1410:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	76(%ebx)
	.cfi_def_cfa_offset 64
	call	tmr_cancel
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1411
	testb	%dl, %dl
	jne	.L1553
.L1411:
	leal	8(%ebx), %edx
	movl	$0, 76(%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1412
	testb	%cl, %cl
	jne	.L1554
.L1412:
	movl	8(%ebx), %edi
	leal	356(%edi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %esi
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movl	%esi, %ecx
	cmpb	%cl, %al
	jl	.L1413
	testb	%cl, %cl
	jne	.L1555
.L1413:
	movl	$0, 356(%edi)
.L1414:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	movl	%ebp, %edx
	movl	%ebx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	jmp	really_clear_connection
.L1539:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1537:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1549:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1548:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1547:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1550:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1538:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1546:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1545:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1542:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1541:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1543:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1544:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1551:
	.cfi_restore_state
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC93
	.cfi_def_cfa_offset 60
	pushl	$2
	.cfi_def_cfa_offset 64
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L1553:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1552:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1555:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1554:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LASANPC26:
.LFB26:
	.cfi_startproc
	leal	8(%eax), %ecx
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	movl	%ecx, %eax
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ecx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1557
	testb	%dl, %dl
	jne	.L1565
.L1557:
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	8(%ebx)
	.cfi_def_cfa_offset 32
	call	httpd_write_response
	addl	$20, %esp
	.cfi_def_cfa_offset 12
	movl	%esi, %edx
	movl	%ebx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	jmp	clear_connection
.L1565:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -12
	.cfi_offset 6, -8
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%ecx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LASANPC20:
.LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$44, %esp
	.cfi_def_cfa_offset 64
	movl	%edx, 12(%esp)
	leal	8(%eax), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1567
	testb	%cl, %cl
	jne	.L1910
.L1567:
	movl	8(%edi), %ebx
	leal	144(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1568
	testb	%dl, %dl
	jne	.L1911
.L1568:
	leal	140(%ebx), %ebp
	movl	144(%ebx), %edx
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1569
	testb	%cl, %cl
	jne	.L1912
.L1569:
	movl	140(%ebx), %eax
	cmpl	%eax, %edx
	jb	.L1913
	cmpl	$5000, %eax
	jbe	.L1571
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1572
	testb	%dl, %dl
	jne	.L1914
.L1572:
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1592
	testb	%dl, %dl
	jne	.L1915
.L1592:
	subl	$8, %esp
	.cfi_def_cfa_offset 72
	pushl	$.LC48
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	pushl	$.LC48
	.cfi_def_cfa_offset 84
	pushl	httpd_err400title
	.cfi_def_cfa_offset 88
	pushl	$400
	.cfi_def_cfa_offset 92
.L1909:
	pushl	%ebx
	.cfi_def_cfa_offset 96
	call	httpd_send_err
	movl	44(%esp), %edx
	movl	%edi, %eax
	addl	$76, %esp
	.cfi_def_cfa_offset 20
.L1907:
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1571:
	.cfi_def_cfa_offset 64
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	addl	$1000, %eax
	pushl	%eax
	.cfi_def_cfa_offset 72
	leal	136(%ebx), %eax
	pushl	%ebp
	.cfi_def_cfa_offset 76
	movl	%eax, 28(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	httpd_realloc_str
	movl	%ebp, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1574
	testb	%dl, %dl
	jne	.L1916
.L1574:
	movl	%esi, %edx
	movl	140(%ebx), %eax
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1575
	testb	%cl, %cl
	jne	.L1917
.L1575:
	movl	144(%ebx), %edx
.L1570:
	subl	%edx, %eax
	movl	%eax, 20(%esp)
	movl	16(%esp), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebp
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%ebp, %eax
	cmpb	%al, %cl
	jl	.L1576
	testb	%al, %al
	jne	.L1918
.L1576:
	addl	136(%ebx), %edx
	leal	448(%ebx), %ebp
	movl	%ebp, %ecx
	andl	$7, %ecx
	movl	%edx, %eax
	movl	%ebp, %edx
	addl	$3, %ecx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %cl
	jl	.L1577
	testb	%dl, %dl
	jne	.L1919
.L1577:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	24(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	448(%ebx)
	.cfi_def_cfa_offset 80
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	je	.L1920
	js	.L1921
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1586
	testb	%cl, %cl
	jne	.L1922
.L1586:
	movl	12(%esp), %esi
	addl	%eax, 144(%ebx)
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1587
	testb	%dl, %dl
	jne	.L1923
.L1587:
	movl	12(%esp), %eax
	leal	68(%edi), %edx
	movl	(%eax), %esi
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1588
	testb	%cl, %cl
	jne	.L1924
.L1588:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	movl	%esi, 68(%edi)
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	httpd_got_request
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	je	.L1566
	cmpl	$2, %eax
	jne	.L1905
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1591
	testb	%dl, %dl
	je	.L1591
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1943:
	.cfi_restore_state
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1623
	testb	%dl, %dl
	jne	.L1925
.L1623:
	movl	12(%esp), %esi
	movl	$2, (%edi)
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1624
	testb	%dl, %dl
	jne	.L1926
.L1624:
	movl	12(%esp), %eax
	leal	64(%edi), %edx
	movl	(%eax), %esi
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1625
	testb	%cl, %cl
	jne	.L1927
.L1625:
	leal	80(%edi), %edx
	movl	%esi, 64(%edi)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1626
	testb	%cl, %cl
	jne	.L1928
.L1626:
	movl	%ebp, %eax
	movl	$0, 80(%edi)
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1627
	testb	%dl, %dl
	jne	.L1929
.L1627:
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	448(%ebx)
	.cfi_def_cfa_offset 80
	call	fdwatch_del_fd
	movl	%ebp, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1628
	testb	%dl, %dl
	jne	.L1930
.L1628:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	$1
	.cfi_def_cfa_offset 72
	pushl	%edi
	.cfi_def_cfa_offset 76
	pushl	448(%ebx)
	.cfi_def_cfa_offset 80
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 64
.L1566:
	addl	$44, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1913:
	.cfi_restore_state
	leal	136(%ebx), %ecx
	movl	%ecx, 16(%esp)
	jmp	.L1570
	.p2align 4,,10
	.p2align 3
.L1921:
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1582
	testb	%cl, %cl
	jne	.L1931
.L1582:
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L1566
	cmpl	$11, %eax
	je	.L1566
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1584
	testb	%dl, %dl
	je	.L1584
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1591:
	.cfi_restore_state
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1592
	testb	%dl, %dl
	je	.L1592
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1584:
	.cfi_restore_state
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1592
	testb	%dl, %dl
	je	.L1592
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1920:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1579
	testb	%dl, %dl
	jne	.L1932
.L1579:
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1592
	testb	%dl, %dl
	je	.L1592
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1905:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	httpd_parse_request
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	js	.L1908
	movl	%edi, %eax
	call	check_throttles
	testl	%eax, %eax
	je	.L1933
	subl	$8, %esp
	.cfi_def_cfa_offset 72
	pushl	20(%esp)
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	httpd_start_request
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	js	.L1908
	leal	336(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1599
	testb	%cl, %cl
	jne	.L1934
.L1599:
	movl	336(%ebx), %edx
	testl	%edx, %edx
	je	.L1600
	leal	344(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1601
	testb	%cl, %cl
	jne	.L1935
.L1601:
	leal	92(%edi), %edx
	movl	344(%ebx), %esi
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1602
	testb	%cl, %cl
	jne	.L1936
.L1602:
	leal	348(%ebx), %edx
	movl	%esi, 92(%edi)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1603
	testb	%cl, %cl
	jne	.L1937
.L1603:
	leal	88(%edi), %esi
	movl	348(%ebx), %eax
	movl	%esi, %edx
	shrl	$3, %edx
	addl	$1, %eax
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1604
	testb	%cl, %cl
	jne	.L1938
.L1604:
	movl	%eax, 88(%edi)
.L1605:
	leal	452(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1610
	testb	%cl, %cl
	jne	.L1939
.L1610:
	movl	452(%ebx), %eax
	testl	%eax, %eax
	je	.L1940
	leal	92(%edi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1621
	testb	%cl, %cl
	jne	.L1941
.L1621:
	movl	%esi, %eax
	movl	92(%edi), %ecx
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1622
	testb	%dl, %dl
	jne	.L1942
.L1622:
	cmpl	88(%edi), %ecx
	jl	.L1943
.L1908:
	movl	12(%esp), %edx
	movl	%edi, %eax
	addl	$44, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	jmp	.L1907
	.p2align 4,,10
	.p2align 3
.L1933:
	.cfi_restore_state
	leal	172(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1595
	testb	%cl, %cl
	jne	.L1944
.L1595:
	movl	$httpd_err503form, %eax
	movl	172(%ebx), %esi
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1596
	testb	%dl, %dl
	jne	.L1945
.L1596:
	movl	$httpd_err503title, %eax
	movl	httpd_err503form, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1597
	testb	%dl, %dl
	jne	.L1946
.L1597:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 72
	pushl	%esi
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	pushl	$.LC48
	.cfi_def_cfa_offset 84
	pushl	httpd_err503title
	.cfi_def_cfa_offset 88
	pushl	$503
	.cfi_def_cfa_offset 92
	jmp	.L1909
.L1912:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1911:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1910:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1916:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1914:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1915:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1931:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1922:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1923:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	24(%esp)
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1924:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1917:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1600:
	.cfi_restore_state
	leal	164(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1606
	testb	%cl, %cl
	jne	.L1947
.L1606:
	movl	164(%ebx), %edx
	leal	88(%edi), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	testl	%edx, %edx
	js	.L1948
	movzbl	536870912(%eax), %ecx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1609
	testb	%cl, %cl
	jne	.L1949
.L1609:
	movl	%edx, 88(%edi)
	jmp	.L1605
.L1940:
	leal	52(%edi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1612
	testb	%cl, %cl
	jne	.L1950
.L1612:
	movl	52(%edi), %eax
	testl	%eax, %eax
	movl	%eax, 20(%esp)
	jle	.L1951
	movl	throttles, %eax
	leal	168(%ebx), %edx
	movl	%eax, 24(%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1616
	testb	%cl, %cl
	jne	.L1952
.L1616:
	movl	168(%ebx), %ebp
	leal	12(%edi), %eax
	xorl	%esi, %esi
	movl	%edi, 28(%esp)
	.p2align 4,,10
	.p2align 3
.L1619:
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1617
	testb	%cl, %cl
	jne	.L1953
.L1617:
	movl	(%eax), %edx
	movl	24(%esp), %edi
	leal	(%edx,%edx,2), %edx
	leal	(%edi,%edx,8), %edi
	leal	16(%edi), %ebx
	movl	%edi, 16(%esp)
	movl	%ebx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %edi
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%edi, %edx
	cmpb	%dl, %cl
	jl	.L1618
	testb	%dl, %dl
	jne	.L1954
.L1618:
	movl	16(%esp), %edi
	addl	$1, %esi
	addl	$4, %eax
	addl	%ebp, 16(%edi)
	cmpl	%esi, 20(%esp)
	jne	.L1619
	movl	28(%esp), %edi
.L1615:
	leal	92(%edi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1620
	testb	%cl, %cl
	jne	.L1955
.L1620:
	movl	%ebp, 92(%edi)
	jmp	.L1908
.L1948:
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1608
	testb	%dl, %dl
	jne	.L1956
.L1608:
	movl	$0, 88(%edi)
	jmp	.L1605
.L1951:
	leal	168(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1614
	testb	%cl, %cl
	jne	.L1957
.L1614:
	movl	168(%ebx), %ebp
	jmp	.L1615
.L1957:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1956:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1952:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1953:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1954:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1955:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1942:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1946:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err503title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1932:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1938:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1939:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1941:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1950:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1947:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1949:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1925:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1926:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	24(%esp)
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1927:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1928:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1929:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1930:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1918:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	28(%esp)
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1935:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1936:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1937:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1944:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1945:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err503form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1919:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1934:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 32
.LC94:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC95:
	.string	"%.80s connection timed out sending"
	.zero	61
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LASANPC29:
.LFB29:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	52(%esp), %ebp
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 11(%esp)
	movl	max_connects, %eax
	testl	%eax, %eax
	jle	.L1958
	xorl	%edi, %edi
	xorl	%esi, %esi
	jmp	.L2017
	.p2align 4,,10
	.p2align 3
.L2045:
	jl	.L1961
	cmpl	$3, %eax
	jg	.L1961
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	cmpb	%al, 11(%esp)
	jl	.L1971
	testb	%al, %al
	jne	.L2041
.L1971:
	leal	68(%ebx), %ecx
	movl	0(%ebp), %eax
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	movb	%dl, 4(%esp)
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	4(%esp), %dl
	jl	.L1972
	cmpb	$0, 4(%esp)
	jne	.L2042
.L1972:
	subl	68(%ebx), %eax
	cmpl	$299, %eax
	jg	.L2043
.L1961:
	addl	$1, %esi
	addl	$96, %edi
	cmpl	%esi, max_connects
	jle	.L1958
.L2017:
	movl	connects, %ebx
	addl	%edi, %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1960
	testb	%dl, %dl
	jne	.L2044
.L1960:
	movl	(%ebx), %eax
	cmpl	$1, %eax
	jne	.L2045
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	cmpb	%al, 11(%esp)
	jl	.L1964
	testb	%al, %al
	jne	.L2046
.L1964:
	leal	68(%ebx), %ecx
	movl	0(%ebp), %eax
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	movb	%dl, 4(%esp)
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	4(%esp), %dl
	jl	.L1965
	cmpb	$0, 4(%esp)
	jne	.L2047
.L1965:
	subl	68(%ebx), %eax
	cmpl	$59, %eax
	jle	.L1961
	leal	8(%ebx), %ecx
	movl	%ecx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ecx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1967
	testb	%dl, %dl
	jne	.L2048
.L1967:
	movl	8(%ebx), %eax
	movl	%ecx, 4(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC94
	.cfi_def_cfa_offset 60
	pushl	$6
	.cfi_def_cfa_offset 64
	call	syslog
	movl	$httpd_err408form, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	4(%esp), %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1968
	testb	%dl, %dl
	jne	.L2049
.L1968:
	movl	httpd_err408form, %eax
	movl	%eax, 4(%esp)
	movl	$httpd_err408title, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L1969
	testb	%dl, %dl
	jne	.L2050
.L1969:
	movl	httpd_err408title, %eax
	movl	%eax, 12(%esp)
	movl	%ecx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ecx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1970
	testb	%dl, %dl
	jne	.L2051
.L1970:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	addl	$1, %esi
	addl	$96, %edi
	pushl	$.LC48
	.cfi_def_cfa_offset 60
	pushl	16(%esp)
	.cfi_def_cfa_offset 64
	pushl	$.LC48
	.cfi_def_cfa_offset 68
	pushl	32(%esp)
	.cfi_def_cfa_offset 72
	pushl	$408
	.cfi_def_cfa_offset 76
	pushl	8(%ebx)
	.cfi_def_cfa_offset 80
	call	httpd_send_err
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	finish_connection
	cmpl	%esi, max_connects
	jg	.L2017
.L1958:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L2043:
	.cfi_restore_state
	leal	8(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1974
	testb	%cl, %cl
	jne	.L2052
.L1974:
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC95
	.cfi_def_cfa_offset 60
	pushl	$6
	.cfi_def_cfa_offset 64
	call	syslog
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	clear_connection
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	jmp	.L1961
.L2052:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2051:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2050:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$httpd_err408title
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2049:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$httpd_err408form
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2048:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2047:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2046:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebp
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2042:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2041:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebp
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2044:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.1
.LC96:
	.string	"1 32 16 2 iv "
	.section	.rodata
	.align 32
.LC97:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC98:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC99:
	.string	"write - %m sending %.80s"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LASANPC21:
.LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$172, %esp
	.cfi_def_cfa_offset 192
	movl	__asan_option_detect_stack_use_after_return, %esi
	leal	64(%esp), %eax
	movl	%edx, 24(%esp)
	testl	%esi, %esi
	movl	%eax, 20(%esp)
	jne	.L2401
.L2053:
	movl	20(%esp), %eax
	leal	96(%eax), %ebx
	movl	%ebx, 8(%esp)
	movl	$1102416563, (%eax)
	movl	$.LC96, 4(%eax)
	movl	$.LASANPC21, 8(%eax)
	shrl	$3, %eax
	movl	%eax, 28(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185335808, 536870916(%eax)
	movl	$-202116109, 536870920(%eax)
	leal	8(%ebp), %eax
	movl	%eax, %edi
	movl	%eax, 32(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2057
	testb	%cl, %cl
	jne	.L2402
.L2057:
	leal	56(%ebp), %eax
	movl	8(%ebp), %edi
	movl	%eax, %esi
	movl	%eax, 44(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2058
	testb	%cl, %cl
	jne	.L2403
.L2058:
	movl	56(%ebp), %ecx
	movl	$1000000000, %eax
	cmpl	$-1, %ecx
	je	.L2059
	leal	3(%ecx), %eax
	testl	%ecx, %ecx
	cmovns	%ecx, %eax
	sarl	$2, %eax
.L2059:
	leal	304(%edi), %esi
	movl	%esi, %ecx
	movl	%esi, 16(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L2060
	testb	%bl, %bl
	jne	.L2404
.L2060:
	movl	304(%edi), %ecx
	testl	%ecx, %ecx
	jne	.L2061
	leal	88(%ebp), %ebx
	movl	%ebx, %edx
	movl	%ebx, 36(%esp)
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2062
	testb	%cl, %cl
	jne	.L2405
.L2062:
	leal	92(%ebp), %esi
	movl	88(%ebp), %ecx
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2063
	testb	%bl, %bl
	jne	.L2406
.L2063:
	movl	92(%ebp), %edx
	leal	452(%edi), %ebx
	subl	%edx, %ecx
	cmpl	%eax, %ecx
	cmovbe	%ecx, %eax
	movl	%ebx, %ecx
	shrl	$3, %ecx
	movl	%eax, 8(%esp)
	movzbl	536870912(%ecx), %eax
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jl	.L2064
	testb	%al, %al
	jne	.L2407
.L2064:
	leal	448(%edi), %eax
	addl	452(%edi), %edx
	movl	%eax, %ecx
	movl	%eax, 40(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L2065
	testb	%bl, %bl
	jne	.L2408
.L2065:
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	pushl	12(%esp)
	.cfi_def_cfa_offset 200
	pushl	%edx
	.cfi_def_cfa_offset 204
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	write
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	12(%esp), %ebx
	testl	%ebx, %ebx
	js	.L2409
.L2072:
	je	.L2076
	movl	24(%esp), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2089
	testb	%dl, %dl
	jne	.L2410
.L2089:
	movl	24(%esp), %eax
	leal	68(%ebp), %edx
	movl	(%eax), %ebx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2090
	testb	%cl, %cl
	jne	.L2411
.L2090:
	movl	%ebx, 68(%ebp)
	movl	16(%esp), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2091
	testb	%dl, %dl
	jne	.L2412
.L2091:
	movl	304(%edi), %eax
	testl	%eax, %eax
	je	.L2092
	cmpl	12(%esp), %eax
	ja	.L2413
	subl	%eax, 12(%esp)
	movl	$0, 304(%edi)
.L2092:
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2095
	testb	%dl, %dl
	jne	.L2414
.L2095:
	movl	12(%esp), %eax
	addl	92(%ebp), %eax
	movl	32(%esp), %esi
	movl	%eax, 48(%esp)
	movl	%eax, 92(%ebp)
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2096
	testb	%dl, %dl
	jne	.L2415
.L2096:
	movl	8(%ebp), %eax
	leal	168(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2097
	testb	%bl, %bl
	jne	.L2416
.L2097:
	movl	12(%esp), %ebx
	addl	168(%eax), %ebx
	leal	52(%ebp), %edx
	movl	%ebx, 168(%eax)
	movl	%edx, %eax
	movl	%ebx, 60(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2098
	testb	%cl, %cl
	jne	.L2417
.L2098:
	movl	52(%ebp), %eax
	xorl	%ebx, %ebx
	movl	%eax, %esi
	movl	%eax, 16(%esp)
	movl	throttles, %eax
	testl	%esi, %esi
	movl	%eax, %ecx
	leal	12(%ebp), %eax
	jle	.L2106
	movl	%ebp, 56(%esp)
	movl	%edi, 52(%esp)
	movl	%ecx, %ebp
	movl	%ebx, 8(%esp)
	.p2align 4,,10
	.p2align 3
.L2303:
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2103
	testb	%cl, %cl
	jne	.L2418
.L2103:
	movl	(%eax), %edx
	leal	(%edx,%edx,2), %edx
	leal	0(%ebp,%edx,8), %edx
	leal	16(%edx), %esi
	movl	%esi, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %edi
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%edi, %ebx
	cmpb	%bl, %cl
	jl	.L2104
	testb	%bl, %bl
	jne	.L2419
.L2104:
	addl	$1, 8(%esp)
	movl	12(%esp), %edi
	addl	$4, %eax
	addl	%edi, 16(%edx)
	movl	16(%esp), %esi
	movl	8(%esp), %edi
	cmpl	%esi, %edi
	jne	.L2303
	movl	52(%esp), %edi
	movl	56(%esp), %ebp
.L2106:
	movl	36(%esp), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2100
	testb	%dl, %dl
	jne	.L2420
.L2100:
	movl	48(%esp), %eax
	cmpl	88(%ebp), %eax
	jge	.L2421
	leal	80(%ebp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2107
	testb	%cl, %cl
	jne	.L2422
.L2107:
	movl	80(%ebp), %eax
	cmpl	$100, %eax
	jle	.L2108
	subl	$100, %eax
	movl	%eax, 80(%ebp)
.L2108:
	movl	44(%esp), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2109
	testb	%dl, %dl
	jne	.L2423
.L2109:
	movl	56(%ebp), %ecx
	cmpl	$-1, %ecx
	je	.L2056
	movl	24(%esp), %eax
	leal	64(%ebp), %edx
	movl	(%eax), %eax
	movl	%eax, 8(%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %esi
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movl	%esi, %ebx
	cmpb	%bl, %al
	jl	.L2110
	testb	%bl, %bl
	jne	.L2424
.L2110:
	movl	8(%esp), %esi
	subl	64(%ebp), %esi
	movl	$1, %eax
	cmove	%eax, %esi
	movl	60(%esp), %eax
	cltd
	idivl	%esi
	cmpl	%eax, %ecx
	jge	.L2056
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2112
	testb	%dl, %dl
	je	.L2112
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebp
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L2061:
	.cfi_restore_state
	leal	252(%edi), %esi
	movl	%esi, %ebx
	movl	%esi, %edx
	shrl	$3, %ebx
	andl	$7, %edx
	movzbl	536870912(%ebx), %ebx
	movb	%bl, 12(%esp)
	movl	%edx, %ebx
	movzbl	12(%esp), %edx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jl	.L2067
	testb	%dl, %dl
	jne	.L2425
.L2067:
	movl	8(%esp), %esi
	movl	252(%edi), %ebx
	movl	%ebx, -64(%esi)
	leal	452(%edi), %ebx
	movl	%ecx, -60(%esi)
	movl	%ebx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %esi
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%esi, %edx
	cmpb	%dl, %cl
	jl	.L2068
	testb	%dl, %dl
	jne	.L2426
.L2068:
	movl	452(%edi), %esi
	movl	%esi, %edx
	leal	92(%ebp), %esi
	movl	%esi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ecx
	movl	%esi, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jl	.L2069
	testb	%cl, %cl
	jne	.L2427
.L2069:
	movl	92(%ebp), %ebx
	movl	%edx, %ecx
	movl	8(%esp), %edx
	addl	%ebx, %ecx
	movl	%ecx, -56(%edx)
	leal	88(%ebp), %ecx
	movl	%ecx, %edx
	movl	%ecx, 36(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	movb	%cl, 12(%esp)
	movl	%edx, %ecx
	movzbl	12(%esp), %edx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L2070
	testb	%dl, %dl
	jne	.L2428
.L2070:
	movl	88(%ebp), %ecx
	subl	%ebx, %ecx
	movl	8(%esp), %ebx
	cmpl	%eax, %ecx
	cmovbe	%ecx, %eax
	movl	%eax, -52(%ebx)
	leal	448(%edi), %eax
	movl	%eax, %ebx
	movl	%eax, 40(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2071
	testb	%cl, %cl
	jne	.L2429
.L2071:
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	pushl	$2
	.cfi_def_cfa_offset 200
	movl	16(%esp), %edx
	subl	$64, %edx
	pushl	%edx
	.cfi_def_cfa_offset 204
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	writev
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	12(%esp), %ebx
	testl	%ebx, %ebx
	jns	.L2072
.L2409:
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2073
	testb	%cl, %cl
	jne	.L2430
.L2073:
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L2056
	cmpl	$11, %eax
	je	.L2076
	cmpl	$32, %eax
	setne	%cl
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L2086
	cmpl	$104, %eax
	je	.L2086
	leal	172(%edi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2087
	testb	%cl, %cl
	jne	.L2431
.L2087:
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	pushl	172(%edi)
	.cfi_def_cfa_offset 200
	pushl	$.LC99
	.cfi_def_cfa_offset 204
	pushl	$3
	.cfi_def_cfa_offset 208
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 192
.L2086:
	movl	24(%esp), %edx
	movl	%ebp, %eax
	call	clear_connection
	jmp	.L2056
	.p2align 4,,10
	.p2align 3
.L2076:
	leal	80(%ebp), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2079
	testb	%dl, %dl
	jne	.L2432
.L2079:
	movl	%ebp, %eax
	addl	$100, 80(%ebp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2080
	testb	%dl, %dl
	jne	.L2433
.L2080:
	movl	40(%esp), %esi
	movl	$3, 0(%ebp)
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2081
	testb	%dl, %dl
	jne	.L2434
.L2081:
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	leal	72(%ebp), %esi
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	fdwatch_del_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2082
	testb	%dl, %dl
	jne	.L2435
.L2082:
	movl	72(%ebp), %ecx
	testl	%ecx, %ecx
	je	.L2083
	subl	$8, %esp
	.cfi_def_cfa_offset 200
	pushl	$.LC97
	.cfi_def_cfa_offset 204
	pushl	$3
	.cfi_def_cfa_offset 208
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 192
.L2083:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2084
	testb	%dl, %dl
	jne	.L2436
.L2084:
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	$0
	.cfi_def_cfa_offset 208
	pushl	80(%ebp)
	.cfi_def_cfa_offset 212
	pushl	%ebp
	.cfi_def_cfa_offset 216
	pushl	$wakeup_connection
	.cfi_def_cfa_offset 220
	pushl	52(%esp)
	.cfi_def_cfa_offset 224
	call	tmr_create
	movl	%esi, %edx
	addl	$32, %esp
	.cfi_def_cfa_offset 192
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2085
	testb	%cl, %cl
	jne	.L2437
.L2085:
	testl	%eax, %eax
	movl	%eax, 72(%ebp)
	je	.L2438
.L2056:
	leal	64(%esp), %eax
	cmpl	20(%esp), %eax
	jne	.L2439
	movl	28(%esp), %eax
	movl	$0, 536870912(%eax)
	movl	$0, 536870916(%eax)
	movl	$0, 536870920(%eax)
.L2055:
	addl	$172, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L2413:
	.cfi_restore_state
	subl	12(%esp), %eax
	leal	252(%edi), %edx
	movl	%eax, %ebx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2094
	testb	%cl, %cl
	je	.L2094
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2112:
	.cfi_restore_state
	movl	40(%esp), %ebx
	movl	$3, 0(%ebp)
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2113
	testb	%dl, %dl
	je	.L2113
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2113:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	fdwatch_del_fd
	movl	48(%esp), %edi
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2114
	testb	%dl, %dl
	je	.L2114
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	44(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2114:
	.cfi_restore_state
	movl	8(%ebp), %ecx
	leal	168(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L2115
	testb	%bl, %bl
	je	.L2115
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2115:
	.cfi_restore_state
	movl	44(%esp), %edi
	movl	168(%ecx), %eax
	movl	%edi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%edi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2116
	testb	%cl, %cl
	je	.L2116
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	56(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2116:
	.cfi_restore_state
	cltd
	idivl	56(%ebp)
	subl	%esi, %eax
	leal	72(%ebp), %esi
	movl	%eax, %ebx
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2117
	testb	%dl, %dl
	je	.L2117
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2117:
	.cfi_restore_state
	movl	72(%ebp), %eax
	testl	%eax, %eax
	je	.L2118
	subl	$8, %esp
	.cfi_def_cfa_offset 200
	pushl	$.LC97
	.cfi_def_cfa_offset 204
	pushl	$3
	.cfi_def_cfa_offset 208
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 192
.L2118:
	imull	$1000, %ebx, %eax
	movl	$500, %edx
	testl	%ebx, %ebx
	cmovle	%edx, %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	$0
	.cfi_def_cfa_offset 208
	pushl	%eax
	.cfi_def_cfa_offset 212
	pushl	%ebp
	.cfi_def_cfa_offset 216
	pushl	$wakeup_connection
	.cfi_def_cfa_offset 220
	pushl	52(%esp)
	.cfi_def_cfa_offset 224
	call	tmr_create
	movl	%esi, %edx
	addl	$32, %esp
	.cfi_def_cfa_offset 192
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2085
	testb	%cl, %cl
	je	.L2085
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L2094:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	movl	252(%edi), %eax
	pushl	%ebx
	.cfi_def_cfa_offset 200
	movl	20(%esp), %edx
	addl	%eax, %edx
	pushl	%edx
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	memmove
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	%ebx, 304(%edi)
	movl	$0, 12(%esp)
	jmp	.L2092
	.p2align 4,,10
	.p2align 3
.L2421:
	movl	24(%esp), %edx
	movl	%ebp, %eax
	call	finish_connection
	jmp	.L2056
.L2402:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	44(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2404:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	28(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2403:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	56(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2439:
	.cfi_restore_state
	movl	20(%esp), %eax
	movl	$1172321806, (%eax)
	movl	28(%esp), %eax
	movl	$-168430091, 536870912(%eax)
	movl	$-168430091, 536870916(%eax)
	movl	$-168430091, 536870920(%eax)
	jmp	.L2055
.L2401:
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	$96
	.cfi_def_cfa_offset 208
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	testl	%eax, %eax
	cmove	20(%esp), %eax
	movl	%eax, 20(%esp)
	jmp	.L2053
.L2408:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2412:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	28(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2410:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	36(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2430:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2422:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2423:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	56(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2433:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebp
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2417:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2418:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2419:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2414:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2415:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	44(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2420:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	48(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2438:
	.cfi_restore_state
	pushl	%edx
	.cfi_remember_state
	.cfi_def_cfa_offset 196
	pushl	%edx
	.cfi_def_cfa_offset 200
	pushl	$.LC98
	.cfi_def_cfa_offset 204
	pushl	$2
	.cfi_def_cfa_offset 208
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2411:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2406:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2405:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	48(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2429:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2428:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	48(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2427:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2426:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2425:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2416:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ecx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2434:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2435:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2436:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2432:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2424:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2437:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2407:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2431:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LASANPC31:
.LFB31:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 16
	leal	16(%esp), %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	leal	16(%esp), %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2441
	testb	%dl, %dl
	jne	.L2456
.L2441:
	movl	16(%esp), %eax
	leal	76(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2442
	testb	%bl, %bl
	jne	.L2457
.L2442:
	movl	20(%esp), %edx
	movl	$0, 76(%eax)
	call	really_clear_connection
	addl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
.L2457:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ecx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L2456:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	leal	28(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.globl	__asan_stack_malloc_7
	.section	.rodata.str1.1
.LC100:
	.string	"1 32 4096 3 buf "
	.globl	__asan_stack_free_7
	.text
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LASANPC22:
.LFB22:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$4188, %esp
	.cfi_def_cfa_offset 4208
	movl	%edx, 12(%esp)
	movl	__asan_option_detect_stack_use_after_return, %edx
	leal	16(%esp), %ebx
	movl	%ebx, %ebp
	testl	%edx, %edx
	jne	.L2490
.L2458:
	leal	4160(%ebx), %eax
	leal	8(%edi), %edx
	movl	%ebx, %esi
	shrl	$3, %esi
	movl	%eax, 8(%esp)
	movl	%edx, %eax
	movl	$1102416563, (%ebx)
	shrl	$3, %eax
	movl	$.LC100, 4(%ebx)
	movl	$.LASANPC22, 8(%ebx)
	movl	$-235802127, 536870912(%esi)
	movl	$-202116109, 536871428(%esi)
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2462
	testb	%cl, %cl
	jne	.L2491
.L2462:
	movl	8(%edi), %ecx
	leal	448(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	movb	%al, 7(%esp)
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	7(%esp), %al
	jl	.L2463
	cmpb	$0, 7(%esp)
	jne	.L2492
.L2463:
	subl	$4, %esp
	.cfi_def_cfa_offset 4212
	pushl	$4096
	.cfi_def_cfa_offset 4216
	movl	16(%esp), %eax
	subl	$4128, %eax
	pushl	%eax
	.cfi_def_cfa_offset 4220
	pushl	448(%ecx)
	.cfi_def_cfa_offset 4224
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 4208
	testl	%eax, %eax
	js	.L2493
	je	.L2467
.L2461:
	cmpl	%ebx, %ebp
	jne	.L2494
	movl	$0, 536870912(%esi)
	movl	$0, 536871428(%esi)
.L2460:
	addl	$4188, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L2493:
	.cfi_restore_state
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2465
	testb	%cl, %cl
	jne	.L2495
.L2465:
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L2461
	cmpl	$11, %eax
	je	.L2461
.L2467:
	movl	12(%esp), %edx
	movl	%edi, %eax
	call	really_clear_connection
	jmp	.L2461
.L2491:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4220
	pushl	%edx
	.cfi_def_cfa_offset 4224
	call	__asan_report_load4
.L2492:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4220
	pushl	%edx
	.cfi_def_cfa_offset 4224
	call	__asan_report_load4
.L2495:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4220
	pushl	%eax
	.cfi_def_cfa_offset 4224
	call	__asan_report_load4
.L2494:
	.cfi_restore_state
	movl	$1172321806, (%ebx)
	pushl	%eax
	.cfi_def_cfa_offset 4212
	pushl	%ebp
	.cfi_def_cfa_offset 4216
	pushl	$4160
	.cfi_def_cfa_offset 4220
	pushl	%ebx
	.cfi_def_cfa_offset 4224
	call	__asan_stack_free_7
	addl	$16, %esp
	.cfi_def_cfa_offset 4208
	jmp	.L2460
.L2490:
	subl	$12, %esp
	.cfi_def_cfa_offset 4220
	pushl	$4160
	.cfi_def_cfa_offset 4224
	call	__asan_stack_malloc_7
	addl	$16, %esp
	.cfi_def_cfa_offset 4208
	testl	%eax, %eax
	cmovne	%eax, %ebx
	jmp	.L2458
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.4
	.align 4
.LC101:
	.string	"3 32 4 2 ai 96 10 7 portstr 160 32 5 hints "
	.section	.rodata
	.align 32
.LC102:
	.string	"%d"
	.zero	61
	.align 32
.LC103:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC104:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC105:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LASANPC37:
.LFB37:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$268, %esp
	.cfi_def_cfa_offset 288
	movl	%eax, 24(%esp)
	leal	32(%esp), %eax
	movl	%edx, 16(%esp)
	movl	%ecx, 28(%esp)
	movl	%eax, 12(%esp)
	movl	__asan_option_detect_stack_use_after_return, %eax
	testl	%eax, %eax
	jne	.L2596
.L2496:
	movl	12(%esp), %ebp
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	leal	224(%ebp), %edi
	leal	160(%ebp), %esi
	movl	%edi, 24(%esp)
	movl	%edi, %ebx
	movl	%ebp, %edi
	shrl	$3, %edi
	movl	$1102416563, 0(%ebp)
	movl	$.LC101, 4(%ebp)
	movl	$.LASANPC37, 8(%ebp)
	movl	$-235802127, 536870912(%edi)
	movl	$-185273340, 536870916(%edi)
	movl	$-218959118, 536870920(%edi)
	movl	$-185335296, 536870924(%edi)
	movl	$-218959118, 536870928(%edi)
	movl	$-202116109, 536870936(%edi)
	pushl	$32
	.cfi_def_cfa_offset 296
	pushl	$0
	.cfi_def_cfa_offset 300
	pushl	%esi
	.cfi_def_cfa_offset 304
	call	memset
	movzwl	port, %eax
	movl	$1, -64(%ebx)
	movl	$1, -56(%ebx)
	leal	96(%ebp), %ebx
	pushl	%eax
	.cfi_def_cfa_offset 308
	pushl	$.LC102
	.cfi_def_cfa_offset 312
	pushl	$10
	.cfi_def_cfa_offset 316
	pushl	%ebx
	.cfi_def_cfa_offset 320
	call	snprintf
	movl	%ebp, %eax
	addl	$32, %esp
	.cfi_def_cfa_offset 288
	addl	$32, %eax
	pushl	%eax
	.cfi_def_cfa_offset 292
	pushl	%esi
	.cfi_def_cfa_offset 296
	pushl	%ebx
	.cfi_def_cfa_offset 300
	pushl	hostname
	.cfi_def_cfa_offset 304
	call	getaddrinfo
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	testl	%eax, %eax
	movl	%eax, %ebx
	jne	.L2597
	movl	20(%esp), %eax
	movl	-192(%eax), %eax
	testl	%eax, %eax
	je	.L2502
	xorl	%ebx, %ebx
	xorl	%esi, %esi
	movl	%ebx, %ebp
	jmp	.L2508
	.p2align 4,,10
	.p2align 3
.L2601:
	cmpl	$10, %edx
	jne	.L2504
	testl	%esi, %esi
	cmove	%eax, %esi
.L2504:
	leal	28(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2507
	testb	%bl, %bl
	jne	.L2598
.L2507:
	movl	28(%eax), %eax
	testl	%eax, %eax
	je	.L2599
.L2508:
	leal	4(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2503
	testb	%bl, %bl
	jne	.L2600
.L2503:
	movl	4(%eax), %edx
	cmpl	$2, %edx
	jne	.L2601
	testl	%ebp, %ebp
	cmove	%eax, %ebp
	jmp	.L2504
	.p2align 4,,10
	.p2align 3
.L2599:
	testl	%esi, %esi
	movl	%ebp, %ebx
	je	.L2602
	leal	16(%esi), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2512
	testb	%cl, %cl
	jne	.L2603
.L2512:
	movl	16(%esi), %eax
	cmpl	$128, %eax
	ja	.L2595
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	pushl	$128
	.cfi_def_cfa_offset 296
	pushl	$0
	.cfi_def_cfa_offset 300
	pushl	40(%esp)
	.cfi_def_cfa_offset 304
	call	memset
	leal	20(%esi), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	16(%esi), %ebp
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2514
	testb	%cl, %cl
	jne	.L2604
.L2514:
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	pushl	%ebp
	.cfi_def_cfa_offset 296
	pushl	20(%esi)
	.cfi_def_cfa_offset 300
	pushl	40(%esp)
	.cfi_def_cfa_offset 304
	call	memmove
	movl	304(%esp), %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	304(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2515
	testb	%dl, %dl
	jne	.L2605
.L2515:
	movl	288(%esp), %eax
	movl	$1, (%eax)
.L2511:
	testl	%ebx, %ebx
	je	.L2606
	leal	16(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2519
	testb	%cl, %cl
	jne	.L2607
.L2519:
	movl	16(%ebx), %eax
	cmpl	$128, %eax
	ja	.L2595
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	pushl	$128
	.cfi_def_cfa_offset 296
	pushl	$0
	.cfi_def_cfa_offset 300
	pushl	36(%esp)
	.cfi_def_cfa_offset 304
	call	memset
	leal	20(%ebx), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	16(%ebx), %esi
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2521
	testb	%cl, %cl
	jne	.L2608
.L2521:
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	pushl	%esi
	.cfi_def_cfa_offset 296
	pushl	20(%ebx)
	.cfi_def_cfa_offset 300
	pushl	36(%esp)
	.cfi_def_cfa_offset 304
	call	memmove
	movl	32(%esp), %esi
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2522
	testb	%dl, %dl
	jne	.L2609
.L2522:
	movl	16(%esp), %eax
	movl	$1, (%eax)
.L2518:
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	movl	32(%esp), %eax
	pushl	-192(%eax)
	.cfi_def_cfa_offset 304
	call	freeaddrinfo
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	leal	32(%esp), %eax
	cmpl	12(%esp), %eax
	jne	.L2610
	movl	$0, 536870912(%edi)
	movl	$0, 536870916(%edi)
	movl	$0, 536870920(%edi)
	movl	$0, 536870924(%edi)
	movl	$0, 536870928(%edi)
	movl	$0, 536870936(%edi)
.L2498:
	addl	$268, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L2602:
	.cfi_restore_state
	movl	%ebp, %eax
.L2502:
	movl	288(%esp), %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	288(%esp), %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2510
	testb	%cl, %cl
	jne	.L2611
.L2510:
	movl	288(%esp), %esi
	movl	%eax, %ebx
	movl	$0, (%esi)
	jmp	.L2511
.L2606:
	movl	16(%esp), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2517
	testb	%dl, %dl
	jne	.L2612
.L2517:
	movl	16(%esp), %eax
	movl	$0, (%eax)
	jmp	.L2518
.L2611:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	300(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2595:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	%eax
	.cfi_def_cfa_offset 304
	pushl	$128
	.cfi_def_cfa_offset 308
	pushl	hostname
	.cfi_def_cfa_offset 312
	pushl	$.LC105
	.cfi_def_cfa_offset 316
	pushl	$2
	.cfi_def_cfa_offset 320
	call	syslog
.L2594:
	addl	$32, %esp
	.cfi_def_cfa_offset 288
	call	__asan_handle_no_return
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	$1
	.cfi_def_cfa_offset 304
	call	exit
.L2597:
	.cfi_def_cfa_offset 288
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	%eax
	.cfi_def_cfa_offset 304
	call	gai_strerror
	pushl	%eax
	.cfi_def_cfa_offset 308
	pushl	hostname
	.cfi_def_cfa_offset 312
	pushl	$.LC103
	.cfi_def_cfa_offset 316
	pushl	$2
	.cfi_def_cfa_offset 320
	call	syslog
	addl	$20, %esp
	.cfi_def_cfa_offset 300
	pushl	%ebx
	.cfi_def_cfa_offset 304
	call	gai_strerror
	movl	$stderr, %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	hostname, %esi
	movl	%edx, %ecx
	andl	$7, %edx
	movl	argv0, %ebx
	shrl	$3, %ecx
	addl	$3, %edx
	movzbl	536870912(%ecx), %ecx
	cmpb	%cl, %dl
	jl	.L2501
	testb	%cl, %cl
	jne	.L2613
.L2501:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%eax
	.cfi_def_cfa_offset 304
	pushl	%esi
	.cfi_def_cfa_offset 308
	pushl	%ebx
	.cfi_def_cfa_offset 312
	pushl	$.LC104
	.cfi_def_cfa_offset 316
	pushl	stderr
	.cfi_def_cfa_offset 320
	call	fprintf
	jmp	.L2594
.L2610:
	.cfi_restore_state
	movl	12(%esp), %eax
	movl	$1172321806, (%eax)
	movl	$-168430091, 536870912(%edi)
	movl	$-168430091, 536870916(%edi)
	movl	$-168430091, 536870920(%edi)
	movl	$-168430091, 536870924(%edi)
	movl	$-168430091, 536870928(%edi)
	movl	$-168430091, 536870932(%edi)
	movl	$-168430091, 536870936(%edi)
	jmp	.L2498
.L2598:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%ecx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2596:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	$224
	.cfi_def_cfa_offset 304
	call	__asan_stack_malloc_2
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	testl	%eax, %eax
	cmove	12(%esp), %eax
	movl	%eax, 12(%esp)
	jmp	.L2496
.L2613:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	$stderr
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2600:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%ecx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2604:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2603:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2609:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	28(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2608:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2607:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2605:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	300(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2612:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	28(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.4
	.align 4
.LC106:
	.string	"6 32 4 5 gotv4 96 4 5 gotv6 160 8 2 tv 224 128 3 sa4 384 128 3 sa6 544 4097 3 cwd "
	.section	.rodata
	.align 32
.LC107:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC108:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC109:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC110:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC111:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC112:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC113:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC114:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC115:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC116:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC117:
	.string	"chdir"
	.zero	58
	.align 32
.LC118:
	.string	"/"
	.zero	62
	.align 32
.LC119:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC120:
	.string	"w"
	.zero	62
	.align 32
.LC121:
	.string	"%d\n"
	.zero	60
	.align 32
.LC122:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC123:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC124:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC125:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC126:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC127:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC128:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC129:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC130:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC131:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC132:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC133:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC134:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC135:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC136:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC137:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC138:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC139:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC140:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LASANPC9:
.LFB9:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x70,0x6
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
	.cfi_escape 0x10,0x6,0x2,0x75,0x78
	.cfi_escape 0x10,0x3,0x2,0x75,0x74
	leal	-4728(%ebp), %esi
	subl	$4744, %esp
	movl	__asan_option_detect_stack_use_after_return, %eax
	movl	(%ecx), %ebx
	movl	4(%ecx), %edi
	testl	%eax, %eax
	jne	.L2984
.L2614:
	leal	4704(%esi), %eax
	movl	%eax, -4736(%ebp)
	movl	%esi, %eax
	movl	$1102416563, (%esi)
	shrl	$3, %eax
	movl	$.LC106, 4(%esi)
	movl	$.LASANPC9, 8(%esi)
	movl	$-235802127, 536870912(%eax)
	movl	$-185273340, 536870916(%eax)
	movl	$-218959118, 536870920(%eax)
	movl	$-185273340, 536870924(%eax)
	movl	$-218959118, 536870928(%eax)
	movl	$-185273344, 536870932(%eax)
	movl	$-218959118, 536870936(%eax)
	movl	$-218959118, 536870956(%eax)
	movl	$-218959118, 536870976(%eax)
	movl	$-185273343, 536871492(%eax)
	movl	$-202116109, 536871496(%eax)
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%edi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2620
	testb	%dl, %dl
	jne	.L2985
.L2620:
	movl	(%edi), %esi
	subl	$8, %esp
	pushl	$47
	pushl	%esi
	movl	%esi, argv0
	call	strrchr
	leal	1(%eax), %edx
	addl	$12, %esp
	testl	%eax, %eax
	pushl	$24
	pushl	$9
	cmovne	%edx, %esi
	pushl	%esi
	call	openlog
	movl	%edi, %edx
	movl	%ebx, %eax
	call	parse_args
	call	tzset
	movl	-4736(%ebp), %edi
	movl	%edi, %eax
	leal	-4320(%edi), %esi
	leal	-4672(%edi), %edx
	subl	$4480, %eax
	movl	%eax, %ebx
	movl	%eax, -4744(%ebp)
	leal	-4608(%edi), %eax
	movl	%esi, %ecx
	movl	%eax, (%esp)
	movl	%ebx, %eax
	call	lookup_hostname.constprop.1
	movl	-4672(%edi), %eax
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2622
	cmpl	$0, -4608(%edi)
	je	.L2986
.L2622:
	movl	throttlefile, %eax
	movl	$0, numthrottles
	movl	$0, maxthrottles
	movl	$0, throttles
	testl	%eax, %eax
	je	.L2624
	call	read_throttlefile
.L2624:
	call	getuid
	testl	%eax, %eax
	movl	$32767, -4748(%ebp)
	movl	$32767, -4752(%ebp)
	je	.L2987
.L2625:
	movl	logfile, %ebx
	testl	%ebx, %ebx
	je	.L2724
	subl	$8, %esp
	pushl	$.LC111
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2631
	movl	$1, no_log
	movl	$0, -4740(%ebp)
.L2630:
	movl	dir, %eax
	testl	%eax, %eax
	je	.L2639
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L2988
.L2639:
	movl	-4736(%ebp), %eax
	subl	$8, %esp
	pushl	$4096
	leal	-4160(%eax), %edi
	pushl	%edi
	call	getcwd
	movl	%edi, (%esp)
	call	strlen
	leal	-1(%eax), %ecx
	addl	$16, %esp
	leal	(%edi,%ecx), %edx
	movl	%edx, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	movb	%bl, -4732(%ebp)
	movl	%edx, %ebx
	andl	$7, %ebx
	cmpb	%bl, -4732(%ebp)
	jg	.L2640
	cmpb	$0, -4732(%ebp)
	jne	.L2989
.L2640:
	movl	-4736(%ebp), %edx
	cmpb	$47, -4160(%ecx,%edx)
	je	.L2641
	addl	%edi, %eax
	pushl	%ebx
	pushl	$2
	pushl	$.LC118
	pushl	%eax
	call	memcpy
	addl	$16, %esp
.L2641:
	movl	debug, %ecx
	testl	%ecx, %ecx
	jne	.L2642
	movl	$stdin, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2643
	testb	%dl, %dl
	jne	.L2990
.L2643:
	subl	$12, %esp
	pushl	stdin
	call	fclose
	movl	$stdout, %eax
	addl	$16, %esp
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2644
	testb	%dl, %dl
	jne	.L2991
.L2644:
	movl	stdout, %eax
	cmpl	%eax, -4740(%ebp)
	je	.L2645
	subl	$12, %esp
	pushl	%eax
	call	fclose
	addl	$16, %esp
.L2645:
	movl	$stderr, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2646
	testb	%dl, %dl
	jne	.L2992
.L2646:
	subl	$12, %esp
	pushl	stderr
	call	fclose
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$1
	call	daemon
	addl	$16, %esp
	testl	%eax, %eax
	js	.L2993
.L2647:
	movl	pidfile, %eax
	testl	%eax, %eax
	je	.L2648
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC120
	pushl	%eax
	call	fopen
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %ebx
	je	.L2994
	call	getpid
	pushl	%edx
	pushl	%eax
	pushl	$.LC121
	pushl	%ebx
	call	fprintf
	movl	%ebx, (%esp)
	call	fclose
	addl	$16, %esp
.L2648:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects
	js	.L2995
	subl	$10, %eax
	cmpl	$0, do_chroot
	movl	%eax, max_connects
	jne	.L2996
.L2651:
	movl	data_dir, %eax
	testl	%eax, %eax
	je	.L2656
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L2997
.L2656:
	pushl	%eax
	pushl	%eax
	pushl	$handle_term
	pushl	$15
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_term
	pushl	$2
	call	sigset
	popl	%ecx
	popl	%ebx
	pushl	$handle_chld
	pushl	$17
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$13
	call	sigset
	popl	%ecx
	popl	%ebx
	pushl	$handle_hup
	pushl	$1
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_usr1
	pushl	$10
	call	sigset
	popl	%ecx
	popl	%ebx
	pushl	$handle_usr2
	pushl	$12
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_alrm
	pushl	$14
	call	sigset
	movl	$360, (%esp)
	movl	$0, got_hup
	movl	$0, got_usr1
	movl	$0, watchdog_flag
	call	alarm
	call	tmr_init
	popl	%ebx
	movl	-4736(%ebp), %ebx
	movzwl	port, %ecx
	popl	%eax
	xorl	%eax, %eax
	cmpl	$0, -4608(%ebx)
	cmove	%eax, %esi
	cmpl	$0, -4672(%ebx)
	pushl	no_empty_referers
	cmovne	-4744(%ebp), %eax
	pushl	local_pattern
	pushl	url_pattern
	pushl	do_global_passwd
	pushl	do_vhost
	pushl	no_symlink_check
	pushl	-4740(%ebp)
	pushl	no_log
	pushl	%edi
	pushl	max_age
	pushl	p3p
	pushl	charset
	pushl	cgi_limit
	pushl	cgi_pattern
	pushl	%ecx
	pushl	%esi
	pushl	%eax
	pushl	hostname
	call	httpd_initialize
	addl	$80, %esp
	testl	%eax, %eax
	movl	%eax, hs
	je	.L2998
	movl	$JunkClientData, %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2660
	testb	%dl, %dl
	jne	.L2999
.L2660:
	subl	$12, %esp
	pushl	$1
	pushl	$120000
	pushl	JunkClientData
	pushl	$occasional
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3000
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2662
	testb	%dl, %dl
	jne	.L3001
.L2662:
	subl	$12, %esp
	pushl	$1
	pushl	$5000
	pushl	JunkClientData
	pushl	$idle
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3002
	cmpl	$0, numthrottles
	jle	.L2664
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2665
	testb	%dl, %dl
	jne	.L3003
.L2665:
	subl	$12, %esp
	pushl	$1
	pushl	$2000
	pushl	JunkClientData
	pushl	$update_throttles
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3004
.L2664:
	movl	%ebx, %eax
	andl	$7, %ebx
	shrl	$3, %eax
	addl	$3, %ebx
	movzbl	536870912(%eax), %eax
	cmpb	%al, %bl
	jl	.L2666
	testb	%al, %al
	jne	.L3005
.L2666:
	subl	$12, %esp
	pushl	$1
	pushl	$3600000
	pushl	JunkClientData
	pushl	$show_stats
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3006
	subl	$12, %esp
	pushl	$0
	call	time
	movl	$0, stats_connections
	movl	%eax, stats_time
	movl	%eax, start_time
	movl	$0, stats_bytes
	movl	$0, stats_simultaneous
	call	getuid
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3007
.L2669:
	movl	max_connects, %esi
	subl	$12, %esp
	imull	$96, %esi, %eax
	pushl	%eax
	movl	%eax, -4740(%ebp)
	call	malloc
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, -4744(%ebp)
	movl	%eax, connects
	je	.L2675
	addl	$4, %eax
	xorl	%edx, %edx
	testl	%esi, %esi
	jle	.L2684
	movl	%edx, -4732(%ebp)
	.p2align 4,,10
	.p2align 3
.L2895:
	leal	-4(%eax), %ebx
	movl	%ebx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %edi
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%edi, %edx
	cmpb	%dl, %cl
	jl	.L2680
	testb	%dl, %dl
	jne	.L3008
.L2680:
	movl	%eax, %ecx
	addl	$1, -4732(%ebp)
	movl	$0, -4(%eax)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jl	.L2681
	testb	%bl, %bl
	jne	.L3009
.L2681:
	leal	4(%eax), %ebx
	movl	-4732(%ebp), %edi
	movl	%ebx, %ecx
	shrl	$3, %ecx
	movl	%edi, (%eax)
	movzbl	536870912(%ecx), %edi
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	movl	%edi, %edx
	cmpb	%dl, %cl
	jl	.L2682
	testb	%dl, %dl
	jne	.L3010
.L2682:
	movl	$0, 4(%eax)
	addl	$96, %eax
	cmpl	-4732(%ebp), %esi
	jne	.L2895
.L2684:
	movl	-4744(%ebp), %eax
	movl	-4740(%ebp), %esi
	leal	-96(%eax,%esi), %ecx
	leal	4(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L2677
	testb	%bl, %bl
	jne	.L3011
.L2677:
	movl	hs, %eax
	movl	$-1, 4(%ecx)
	movl	$0, first_free_connect
	movl	$0, num_connects
	movl	$0, httpd_conn_count
	testl	%eax, %eax
	je	.L2685
	leal	40(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2686
	testb	%bl, %bl
	jne	.L3012
.L2686:
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L2687
	pushl	%esi
	pushl	$0
	pushl	$0
	pushl	%edx
	call	fdwatch_add_fd
	movl	hs, %eax
	addl	$16, %esp
.L2687:
	leal	44(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2688
	testb	%bl, %bl
	jne	.L3013
.L2688:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L2685
	pushl	%ebx
	pushl	$0
	pushl	$0
	pushl	%eax
	call	fdwatch_add_fd
	addl	$16, %esp
.L2685:
	movl	-4736(%ebp), %esi
	subl	$12, %esp
	subl	$4544, %esi
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	.p2align 4,,10
	.p2align 3
.L2689:
	movl	terminate, %edx
	testl	%edx, %edx
	je	.L2722
	cmpl	$0, num_connects
	jle	.L3014
.L2722:
	movl	got_hup, %eax
	testl	%eax, %eax
	jne	.L3015
.L2690:
	subl	$12, %esp
	pushl	%esi
	call	tmr_mstimeout
	movl	%eax, (%esp)
	call	fdwatch
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L3016
	subl	$12, %esp
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	testl	%ebx, %ebx
	je	.L3017
	movl	hs, %eax
	testl	%eax, %eax
	je	.L2708
	leal	44(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2699
	testb	%bl, %bl
	jne	.L3018
.L2699:
	movl	44(%eax), %edx
	cmpl	$-1, %edx
	je	.L2700
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2701
.L2705:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L2708
.L2700:
	leal	40(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2706
	testb	%bl, %bl
	jne	.L3019
.L2706:
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L2708
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L3020
	.p2align 4,,10
	.p2align 3
.L2708:
	call	fdwatch_get_next_client_data
	cmpl	$-1, %eax
	movl	%eax, %ebx
	je	.L3021
	testl	%ebx, %ebx
	je	.L2708
	leal	8(%ebx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L2709
	testb	%cl, %cl
	jne	.L3022
.L2709:
	movl	8(%ebx), %eax
	leal	448(%eax), %edx
	movl	%eax, -4732(%ebp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edi
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movl	%edi, %ecx
	cmpb	%cl, %al
	jl	.L2710
	testb	%cl, %cl
	jne	.L3023
.L2710:
	movl	-4732(%ebp), %eax
	subl	$12, %esp
	pushl	448(%eax)
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3024
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %edx
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L2713
	testb	%dl, %dl
	jne	.L3025
.L2713:
	movl	(%ebx), %eax
	cmpl	$2, %eax
	je	.L2714
	cmpl	$4, %eax
	je	.L2715
	cmpl	$1, %eax
	jne	.L2708
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_read
	jmp	.L2708
.L2631:
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC82
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2632
	movl	$stdout, %eax
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2633
	testb	%dl, %dl
	jne	.L3026
.L2633:
	movl	stdout, %eax
	movl	%eax, -4740(%ebp)
	jmp	.L2630
.L2642:
	call	setsid
	jmp	.L2647
.L2987:
	subl	$12, %esp
	pushl	user
	call	getpwnam
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3027
	leal	8(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2628
	testb	%bl, %bl
	jne	.L3028
.L2628:
	leal	12(%eax), %ecx
	movl	8(%eax), %edi
	movl	%ecx, %edx
	shrl	$3, %edx
	movl	%edi, -4752(%ebp)
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2629
	testb	%bl, %bl
	jne	.L3029
.L2629:
	movl	12(%eax), %eax
	movl	%eax, -4748(%ebp)
	jmp	.L2625
.L2986:
	pushl	%edi
	pushl	%edi
	pushl	$.LC107
	pushl	$3
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2623
	testb	%dl, %dl
	jne	.L3030
.L2623:
	pushl	%esi
	pushl	%ecx
	pushl	$.LC108
.L2982:
	pushl	stderr
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3007:
	pushl	%edx
	pushl	%edx
	pushl	$0
	pushl	$0
	call	setgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3031
	subl	$12, %esp
	pushl	-4748(%ebp)
	call	setgid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3032
	pushl	%eax
	pushl	%eax
	pushl	-4748(%ebp)
	pushl	user
	call	initgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3033
.L2672:
	subl	$12, %esp
	pushl	-4752(%ebp)
	call	setuid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3034
	cmpl	$0, do_chroot
	jne	.L2669
	pushl	%eax
	pushl	%eax
	pushl	$.LC138
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L2669
.L3024:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	clear_connection
	jmp	.L2708
.L3016:
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L2692
	testb	%cl, %cl
	jne	.L3035
.L2692:
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L2689
	cmpl	$11, %eax
	je	.L2689
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC140
	pushl	$3
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2715:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_linger
	jmp	.L2708
.L2714:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_send
	jmp	.L2708
.L3021:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	movl	got_usr1, %eax
	addl	$16, %esp
	testl	%eax, %eax
	je	.L2689
	cmpl	$0, terminate
	jne	.L2689
	movl	hs, %eax
	movl	$1, terminate
	testl	%eax, %eax
	je	.L2689
	leal	40(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2718
	testb	%bl, %bl
	je	.L2718
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L2718:
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L2719
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_del_fd
	movl	hs, %eax
	addl	$16, %esp
.L2719:
	leal	44(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jl	.L2720
	testb	%bl, %bl
	je	.L2720
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L2720:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L2721
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_del_fd
	addl	$16, %esp
.L2721:
	subl	$12, %esp
	pushl	hs
	call	httpd_unlisten
	addl	$16, %esp
	jmp	.L2689
.L3015:
	call	re_open_logfile
	movl	$0, got_hup
	jmp	.L2690
.L3017:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	addl	$16, %esp
	jmp	.L2689
.L2996:
	subl	$12, %esp
	pushl	%edi
	call	chroot
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3036
	movl	logfile, %ebx
	testl	%ebx, %ebx
	je	.L2653
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC82
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	je	.L2653
	subl	$12, %esp
	pushl	%edi
	call	strlen
	addl	$12, %esp
	movl	%eax, -4732(%ebp)
	pushl	%eax
	pushl	%edi
	pushl	%ebx
	call	strncmp
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3037
	pushl	%eax
	pushl	%eax
	pushl	$.LC124
	pushl	$4
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2655
	testb	%dl, %dl
	jne	.L3038
.L2655:
	pushl	%eax
	pushl	%ecx
	pushl	$.LC125
	pushl	stderr
	call	fprintf
	addl	$16, %esp
.L2653:
	pushl	%eax
	pushl	$2
	pushl	$.LC118
	pushl	%edi
	call	memcpy
	movl	%edi, (%esp)
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L2651
	pushl	%eax
	pushl	%eax
	pushl	$.LC126
	pushl	$2
	call	syslog
	movl	$.LC127, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2724:
	movl	$0, -4740(%ebp)
	jmp	.L2630
.L2632:
	pushl	%eax
	pushl	%eax
	pushl	$.LC84
	pushl	%ebx
	call	fopen
	movl	logfile, %ebx
	movl	%eax, %edi
	movl	%eax, -4740(%ebp)
	popl	%eax
	popl	%edx
	pushl	$384
	pushl	%ebx
	call	chmod
	addl	$16, %esp
	testl	%edi, %edi
	je	.L2727
	testl	%eax, %eax
	jne	.L2727
	movl	%ebx, %eax
	movl	%ebx, %edx
	shrl	$3, %eax
	andl	$7, %edx
	movzbl	536870912(%eax), %eax
	cmpb	%dl, %al
	jg	.L2636
	testb	%al, %al
	je	.L2636
	subl	$12, %esp
	pushl	%ebx
	call	__asan_report_load1
.L2636:
	cmpb	$47, (%ebx)
	je	.L2637
	pushl	%eax
	pushl	%eax
	pushl	$.LC112
	pushl	$4
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	argv0, %ecx
	movl	%eax, %edx
	andl	$7, %eax
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2638
	testb	%dl, %dl
	jne	.L3039
.L2638:
	pushl	%eax
	pushl	%ecx
	pushl	$.LC113
	pushl	stderr
	call	fprintf
	addl	$16, %esp
.L2637:
	subl	$12, %esp
	pushl	-4740(%ebp)
	call	fileno
	addl	$12, %esp
	pushl	$1
	pushl	$2
	pushl	%eax
	call	fcntl
	call	getuid
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2630
	subl	$12, %esp
	pushl	-4740(%ebp)
	call	fileno
	addl	$12, %esp
	pushl	-4748(%ebp)
	pushl	-4752(%ebp)
	pushl	%eax
	call	fchown
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L2630
	pushl	%edi
	pushl	%edi
	pushl	$.LC114
	pushl	$4
	call	syslog
	movl	$.LC115, (%esp)
	call	perror
	addl	$16, %esp
	jmp	.L2630
.L2988:
	pushl	%esi
	pushl	%esi
	pushl	$.LC116
	pushl	$2
	call	syslog
	movl	$.LC117, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2994:
	pushl	%ecx
	pushl	pidfile
	pushl	$.LC74
.L2983:
	pushl	$2
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2995:
	pushl	%esi
	pushl	%esi
	pushl	$.LC122
	jmp	.L2983
.L2998:
	call	__asan_handle_no_return
	subl	$12, %esp
	pushl	$1
	call	exit
.L3000:
	pushl	%edi
	pushl	%edi
	pushl	$.LC130
	jmp	.L2983
.L2997:
	pushl	%eax
	pushl	%eax
	pushl	$.LC128
	pushl	$2
	call	syslog
	movl	$.LC129, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3037:
	pushl	%edx
	pushl	%edx
	movl	-4732(%ebp), %edx
	leal	-1(%ebx,%edx), %eax
	pushl	%eax
	pushl	%ebx
	call	strcpy
	addl	$16, %esp
	jmp	.L2653
.L3004:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC132
	jmp	.L2983
.L2993:
	pushl	%esi
	pushl	%esi
	pushl	$.LC119
	jmp	.L2983
.L2701:
	movl	hs, %ecx
	leal	44(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L2703
	testb	%bl, %bl
	jne	.L3040
.L2703:
	movl	44(%ecx), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L2689
	jmp	.L2705
.L3020:
	movl	hs, %ecx
	leal	40(%ecx), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %ebx
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jl	.L2707
	testb	%bl, %bl
	jne	.L3041
.L2707:
	movl	40(%ecx), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L2689
	jmp	.L2708
.L3006:
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC133
	jmp	.L2983
.L3031:
	pushl	%eax
	pushl	%eax
	pushl	$.LC134
	jmp	.L2983
.L2727:
	pushl	%eax
	pushl	%ebx
	pushl	$.LC74
	pushl	$2
	call	syslog
	popl	%eax
	pushl	logfile
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3032:
	pushl	%eax
	pushl	%eax
	pushl	$.LC135
	jmp	.L2983
.L3014:
	call	shut_down
	pushl	%eax
	pushl	%eax
	pushl	$.LC90
	pushl	$5
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$0, (%esp)
	call	exit
.L3002:
	pushl	%esi
	pushl	%esi
	pushl	$.LC131
	jmp	.L2983
.L3036:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC123
	pushl	$2
	call	syslog
	movl	$.LC21, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3027:
	pushl	%ebx
	pushl	user
	pushl	$.LC109
	pushl	$2
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	user, %ebx
	movl	%eax, %edx
	andl	$7, %eax
	movl	argv0, %ecx
	shrl	$3, %edx
	addl	$3, %eax
	movzbl	536870912(%edx), %edx
	cmpb	%dl, %al
	jl	.L2627
	testb	%dl, %dl
	jne	.L3042
.L2627:
	pushl	%ebx
	pushl	%ecx
	pushl	$.LC110
	jmp	.L2982
.L2675:
	pushl	%edi
	pushl	%edi
	pushl	$.LC139
	jmp	.L2983
.L3033:
	pushl	%eax
	pushl	%eax
	pushl	$.LC136
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L2672
.L3034:
	pushl	%eax
	pushl	%eax
	pushl	$.LC137
	jmp	.L2983
.L2984:
	subl	$12, %esp
	pushl	$4704
	call	__asan_stack_malloc_7
	addl	$16, %esp
	testl	%eax, %eax
	cmovne	%eax, %esi
	jmp	.L2614
.L2989:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load1
.L2985:
	subl	$12, %esp
	pushl	%edi
	call	__asan_report_load4
.L3041:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3039:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3038:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3035:
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_load4
.L3026:
	subl	$12, %esp
	pushl	$stdout
	call	__asan_report_load4
.L3005:
	subl	$12, %esp
	pushl	$JunkClientData
	call	__asan_report_load4
.L3030:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3001:
	subl	$12, %esp
	pushl	$JunkClientData
	call	__asan_report_load4
.L2999:
	subl	$12, %esp
	pushl	%ebx
	call	__asan_report_load4
.L2990:
	subl	$12, %esp
	pushl	$stdin
	call	__asan_report_load4
.L2991:
	subl	$12, %esp
	pushl	$stdout
	call	__asan_report_load4
.L2992:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3003:
	subl	$12, %esp
	pushl	$JunkClientData
	call	__asan_report_load4
.L3042:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3028:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L3029:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L3012:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L3011:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_store4
.L3010:
	subl	$12, %esp
	pushl	%ebx
	call	__asan_report_store4
.L3009:
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_store4
.L3008:
	subl	$12, %esp
	pushl	%ebx
	call	__asan_report_store4
.L3013:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L3025:
	subl	$12, %esp
	pushl	%ebx
	call	__asan_report_load4
.L3018:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L3040:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3019:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_load4
.L3023:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3022:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,4,4
	.comm	stats_connections,4,4
	.comm	stats_time,4,4
	.comm	start_time,4,4
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 4
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 4
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 4
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 4
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 4
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 4
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 4
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 4
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 4
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 4
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 4
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 4
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 4
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 4
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 4
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 4
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC141:
	.string	"thttpd.c"
	.data
	.align 4
	.type	.LASANLOC1, @object
	.size	.LASANLOC1, 12
.LASANLOC1:
	.long	.LC141
	.long	135
	.long	40
	.align 4
	.type	.LASANLOC2, @object
	.size	.LASANLOC2, 12
.LASANLOC2:
	.long	.LC141
	.long	135
	.long	30
	.align 4
	.type	.LASANLOC3, @object
	.size	.LASANLOC3, 12
.LASANLOC3:
	.long	.LC141
	.long	135
	.long	21
	.align 4
	.type	.LASANLOC4, @object
	.size	.LASANLOC4, 12
.LASANLOC4:
	.long	.LC141
	.long	129
	.long	5
	.align 4
	.type	.LASANLOC5, @object
	.size	.LASANLOC5, 12
.LASANLOC5:
	.long	.LC141
	.long	128
	.long	22
	.align 4
	.type	.LASANLOC6, @object
	.size	.LASANLOC6, 12
.LASANLOC6:
	.long	.LC141
	.long	118
	.long	12
	.align 4
	.type	.LASANLOC7, @object
	.size	.LASANLOC7, 12
.LASANLOC7:
	.long	.LC141
	.long	117
	.long	40
	.align 4
	.type	.LASANLOC8, @object
	.size	.LASANLOC8, 12
.LASANLOC8:
	.long	.LC141
	.long	117
	.long	26
	.align 4
	.type	.LASANLOC9, @object
	.size	.LASANLOC9, 12
.LASANLOC9:
	.long	.LC141
	.long	117
	.long	12
	.align 4
	.type	.LASANLOC10, @object
	.size	.LASANLOC10, 12
.LASANLOC10:
	.long	.LC141
	.long	116
	.long	20
	.align 4
	.type	.LASANLOC11, @object
	.size	.LASANLOC11, 12
.LASANLOC11:
	.long	.LC141
	.long	96
	.long	26
	.align 4
	.type	.LASANLOC12, @object
	.size	.LASANLOC12, 12
.LASANLOC12:
	.long	.LC141
	.long	96
	.long	12
	.align 4
	.type	.LASANLOC13, @object
	.size	.LASANLOC13, 12
.LASANLOC13:
	.long	.LC141
	.long	95
	.long	21
	.align 4
	.type	.LASANLOC14, @object
	.size	.LASANLOC14, 12
.LASANLOC14:
	.long	.LC141
	.long	85
	.long	12
	.align 4
	.type	.LASANLOC15, @object
	.size	.LASANLOC15, 12
.LASANLOC15:
	.long	.LC141
	.long	84
	.long	14
	.align 4
	.type	.LASANLOC16, @object
	.size	.LASANLOC16, 12
.LASANLOC16:
	.long	.LC141
	.long	83
	.long	14
	.align 4
	.type	.LASANLOC17, @object
	.size	.LASANLOC17, 12
.LASANLOC17:
	.long	.LC141
	.long	82
	.long	14
	.align 4
	.type	.LASANLOC18, @object
	.size	.LASANLOC18, 12
.LASANLOC18:
	.long	.LC141
	.long	81
	.long	14
	.align 4
	.type	.LASANLOC19, @object
	.size	.LASANLOC19, 12
.LASANLOC19:
	.long	.LC141
	.long	80
	.long	14
	.align 4
	.type	.LASANLOC20, @object
	.size	.LASANLOC20, 12
.LASANLOC20:
	.long	.LC141
	.long	79
	.long	14
	.align 4
	.type	.LASANLOC21, @object
	.size	.LASANLOC21, 12
.LASANLOC21:
	.long	.LC141
	.long	78
	.long	14
	.align 4
	.type	.LASANLOC22, @object
	.size	.LASANLOC22, 12
.LASANLOC22:
	.long	.LC141
	.long	77
	.long	14
	.align 4
	.type	.LASANLOC23, @object
	.size	.LASANLOC23, 12
.LASANLOC23:
	.long	.LC141
	.long	76
	.long	12
	.align 4
	.type	.LASANLOC24, @object
	.size	.LASANLOC24, 12
.LASANLOC24:
	.long	.LC141
	.long	75
	.long	14
	.align 4
	.type	.LASANLOC25, @object
	.size	.LASANLOC25, 12
.LASANLOC25:
	.long	.LC141
	.long	74
	.long	12
	.align 4
	.type	.LASANLOC26, @object
	.size	.LASANLOC26, 12
.LASANLOC26:
	.long	.LC141
	.long	73
	.long	14
	.align 4
	.type	.LASANLOC27, @object
	.size	.LASANLOC27, 12
.LASANLOC27:
	.long	.LC141
	.long	72
	.long	59
	.align 4
	.type	.LASANLOC28, @object
	.size	.LASANLOC28, 12
.LASANLOC28:
	.long	.LC141
	.long	72
	.long	49
	.align 4
	.type	.LASANLOC29, @object
	.size	.LASANLOC29, 12
.LASANLOC29:
	.long	.LC141
	.long	72
	.long	31
	.align 4
	.type	.LASANLOC30, @object
	.size	.LASANLOC30, 12
.LASANLOC30:
	.long	.LC141
	.long	72
	.long	23
	.align 4
	.type	.LASANLOC31, @object
	.size	.LASANLOC31, 12
.LASANLOC31:
	.long	.LC141
	.long	72
	.long	12
	.align 4
	.type	.LASANLOC32, @object
	.size	.LASANLOC32, 12
.LASANLOC32:
	.long	.LC141
	.long	71
	.long	14
	.align 4
	.type	.LASANLOC33, @object
	.size	.LASANLOC33, 12
.LASANLOC33:
	.long	.LC141
	.long	70
	.long	14
	.align 4
	.type	.LASANLOC34, @object
	.size	.LASANLOC34, 12
.LASANLOC34:
	.long	.LC141
	.long	69
	.long	23
	.align 4
	.type	.LASANLOC35, @object
	.size	.LASANLOC35, 12
.LASANLOC35:
	.long	.LC141
	.long	68
	.long	12
	.align 4
	.type	.LASANLOC36, @object
	.size	.LASANLOC36, 12
.LASANLOC36:
	.long	.LC141
	.long	67
	.long	14
	.section	.rodata.str1.1
.LC142:
	.string	"watchdog_flag"
.LC143:
	.string	"got_usr1"
.LC144:
	.string	"got_hup"
.LC145:
	.string	"terminate"
.LC146:
	.string	"hs"
.LC147:
	.string	"httpd_conn_count"
.LC148:
	.string	"first_free_connect"
.LC149:
	.string	"max_connects"
.LC150:
	.string	"num_connects"
.LC151:
	.string	"connects"
.LC152:
	.string	"maxthrottles"
.LC153:
	.string	"numthrottles"
.LC154:
	.string	"hostname"
.LC155:
	.string	"throttlefile"
.LC156:
	.string	"local_pattern"
.LC157:
	.string	"no_empty_referers"
.LC158:
	.string	"url_pattern"
.LC159:
	.string	"cgi_limit"
.LC160:
	.string	"cgi_pattern"
.LC161:
	.string	"do_global_passwd"
.LC162:
	.string	"do_vhost"
.LC163:
	.string	"no_symlink_check"
.LC164:
	.string	"no_log"
.LC165:
	.string	"do_chroot"
.LC166:
	.string	"argv0"
.LC167:
	.string	"*.LC95"
.LC168:
	.string	"*.LC116"
.LC169:
	.string	"*.LC39"
.LC170:
	.string	"*.LC83"
.LC171:
	.string	"*.LC136"
.LC172:
	.string	"*.LC79"
.LC173:
	.string	"*.LC80"
.LC174:
	.string	"*.LC2"
.LC175:
	.string	"*.LC128"
.LC176:
	.string	"*.LC131"
.LC177:
	.string	"*.LC69"
.LC178:
	.string	"*.LC35"
.LC179:
	.string	"*.LC60"
.LC180:
	.string	"*.LC76"
.LC181:
	.string	"*.LC62"
.LC182:
	.string	"*.LC82"
.LC183:
	.string	"*.LC54"
.LC184:
	.string	"*.LC123"
.LC185:
	.string	"*.LC129"
.LC186:
	.string	"*.LC36"
.LC187:
	.string	"*.LC21"
.LC188:
	.string	"*.LC32"
.LC189:
	.string	"*.LC135"
.LC190:
	.string	"*.LC55"
.LC191:
	.string	"*.LC45"
.LC192:
	.string	"*.LC103"
.LC193:
	.string	"*.LC29"
.LC194:
	.string	"*.LC7"
.LC195:
	.string	"*.LC4"
.LC196:
	.string	"*.LC107"
.LC197:
	.string	"*.LC105"
.LC198:
	.string	"*.LC75"
.LC199:
	.string	"*.LC77"
.LC200:
	.string	"*.LC115"
.LC201:
	.string	"*.LC31"
.LC202:
	.string	"*.LC40"
.LC203:
	.string	"*.LC49"
.LC204:
	.string	"*.LC56"
.LC205:
	.string	"*.LC41"
.LC206:
	.string	"*.LC118"
.LC207:
	.string	"*.LC61"
.LC208:
	.string	"*.LC30"
.LC209:
	.string	"*.LC0"
.LC210:
	.string	"*.LC84"
.LC211:
	.string	"*.LC137"
.LC212:
	.string	"*.LC121"
.LC213:
	.string	"*.LC12"
.LC214:
	.string	"*.LC134"
.LC215:
	.string	"*.LC46"
.LC216:
	.string	"*.LC47"
.LC217:
	.string	"*.LC102"
.LC218:
	.string	"*.LC127"
.LC219:
	.string	"*.LC43"
.LC220:
	.string	"*.LC98"
.LC221:
	.string	"*.LC19"
.LC222:
	.string	"*.LC25"
.LC223:
	.string	"*.LC126"
.LC224:
	.string	"*.LC109"
.LC225:
	.string	"*.LC110"
.LC226:
	.string	"*.LC140"
.LC227:
	.string	"*.LC20"
.LC228:
	.string	"*.LC50"
.LC229:
	.string	"*.LC72"
.LC230:
	.string	"*.LC88"
.LC231:
	.string	"*.LC66"
.LC232:
	.string	"*.LC63"
.LC233:
	.string	"*.LC64"
.LC234:
	.string	"*.LC113"
.LC235:
	.string	"*.LC16"
.LC236:
	.string	"*.LC120"
.LC237:
	.string	"*.LC119"
.LC238:
	.string	"*.LC78"
.LC239:
	.string	"*.LC122"
.LC240:
	.string	"*.LC5"
.LC241:
	.string	"*.LC124"
.LC242:
	.string	"*.LC17"
.LC243:
	.string	"*.LC67"
.LC244:
	.string	"*.LC22"
.LC245:
	.string	"*.LC42"
.LC246:
	.string	"*.LC65"
.LC247:
	.string	"*.LC26"
.LC248:
	.string	"*.LC85"
.LC249:
	.string	"*.LC33"
.LC250:
	.string	"*.LC48"
.LC251:
	.string	"*.LC117"
.LC252:
	.string	"*.LC125"
.LC253:
	.string	"*.LC104"
.LC254:
	.string	"*.LC99"
.LC255:
	.string	"*.LC138"
.LC256:
	.string	"*.LC94"
.LC257:
	.string	"*.LC74"
.LC258:
	.string	"*.LC9"
.LC259:
	.string	"*.LC133"
.LC260:
	.string	"*.LC70"
.LC261:
	.string	"*.LC81"
.LC262:
	.string	"*.LC53"
.LC263:
	.string	"*.LC68"
.LC264:
	.string	"*.LC57"
.LC265:
	.string	"*.LC89"
.LC266:
	.string	"*.LC139"
.LC267:
	.string	"*.LC3"
.LC268:
	.string	"*.LC92"
.LC269:
	.string	"*.LC6"
.LC270:
	.string	"*.LC93"
.LC271:
	.string	"*.LC132"
.LC272:
	.string	"*.LC97"
.LC273:
	.string	"*.LC90"
.LC274:
	.string	"*.LC23"
.LC275:
	.string	"*.LC58"
.LC276:
	.string	"*.LC10"
.LC277:
	.string	"*.LC114"
.LC278:
	.string	"*.LC111"
.LC279:
	.string	"*.LC86"
.LC280:
	.string	"*.LC34"
.LC281:
	.string	"*.LC130"
.LC282:
	.string	"*.LC44"
.LC283:
	.string	"*.LC27"
.LC284:
	.string	"*.LC87"
.LC285:
	.string	"*.LC91"
.LC286:
	.string	"*.LC51"
.LC287:
	.string	"*.LC71"
.LC288:
	.string	"*.LC38"
.LC289:
	.string	"*.LC52"
.LC290:
	.string	"*.LC59"
.LC291:
	.string	"*.LC37"
.LC292:
	.string	"*.LC28"
.LC293:
	.string	"*.LC13"
.LC294:
	.string	"*.LC14"
.LC295:
	.string	"*.LC108"
.LC296:
	.string	"*.LC24"
.LC297:
	.string	"*.LC112"
.LC298:
	.string	"*.LC18"
	.data
	.align 32
	.type	.LASAN0, @object
	.size	.LASAN0, 4704
.LASAN0:
	.long	watchdog_flag
	.long	4
	.long	64
	.long	.LC142
	.long	.LC141
	.long	0
	.long	.LASANLOC1
	.long	got_usr1
	.long	4
	.long	64
	.long	.LC143
	.long	.LC141
	.long	0
	.long	.LASANLOC2
	.long	got_hup
	.long	4
	.long	64
	.long	.LC144
	.long	.LC141
	.long	0
	.long	.LASANLOC3
	.long	terminate
	.long	4
	.long	64
	.long	.LC145
	.long	.LC141
	.long	0
	.long	.LASANLOC4
	.long	hs
	.long	4
	.long	64
	.long	.LC146
	.long	.LC141
	.long	0
	.long	.LASANLOC5
	.long	httpd_conn_count
	.long	4
	.long	64
	.long	.LC147
	.long	.LC141
	.long	0
	.long	.LASANLOC6
	.long	first_free_connect
	.long	4
	.long	64
	.long	.LC148
	.long	.LC141
	.long	0
	.long	.LASANLOC7
	.long	max_connects
	.long	4
	.long	64
	.long	.LC149
	.long	.LC141
	.long	0
	.long	.LASANLOC8
	.long	num_connects
	.long	4
	.long	64
	.long	.LC150
	.long	.LC141
	.long	0
	.long	.LASANLOC9
	.long	connects
	.long	4
	.long	64
	.long	.LC151
	.long	.LC141
	.long	0
	.long	.LASANLOC10
	.long	maxthrottles
	.long	4
	.long	64
	.long	.LC152
	.long	.LC141
	.long	0
	.long	.LASANLOC11
	.long	numthrottles
	.long	4
	.long	64
	.long	.LC153
	.long	.LC141
	.long	0
	.long	.LASANLOC12
	.long	throttles
	.long	4
	.long	64
	.long	.LC34
	.long	.LC141
	.long	0
	.long	.LASANLOC13
	.long	max_age
	.long	4
	.long	64
	.long	.LC44
	.long	.LC141
	.long	0
	.long	.LASANLOC14
	.long	p3p
	.long	4
	.long	64
	.long	.LC43
	.long	.LC141
	.long	0
	.long	.LASANLOC15
	.long	charset
	.long	4
	.long	64
	.long	.LC42
	.long	.LC141
	.long	0
	.long	.LASANLOC16
	.long	user
	.long	4
	.long	64
	.long	.LC28
	.long	.LC141
	.long	0
	.long	.LASANLOC17
	.long	pidfile
	.long	4
	.long	64
	.long	.LC41
	.long	.LC141
	.long	0
	.long	.LASANLOC18
	.long	hostname
	.long	4
	.long	64
	.long	.LC154
	.long	.LC141
	.long	0
	.long	.LASANLOC19
	.long	throttlefile
	.long	4
	.long	64
	.long	.LC155
	.long	.LC141
	.long	0
	.long	.LASANLOC20
	.long	logfile
	.long	4
	.long	64
	.long	.LC36
	.long	.LC141
	.long	0
	.long	.LASANLOC21
	.long	local_pattern
	.long	4
	.long	64
	.long	.LC156
	.long	.LC141
	.long	0
	.long	.LASANLOC22
	.long	no_empty_referers
	.long	4
	.long	64
	.long	.LC157
	.long	.LC141
	.long	0
	.long	.LASANLOC23
	.long	url_pattern
	.long	4
	.long	64
	.long	.LC158
	.long	.LC141
	.long	0
	.long	.LASANLOC24
	.long	cgi_limit
	.long	4
	.long	64
	.long	.LC159
	.long	.LC141
	.long	0
	.long	.LASANLOC25
	.long	cgi_pattern
	.long	4
	.long	64
	.long	.LC160
	.long	.LC141
	.long	0
	.long	.LASANLOC26
	.long	do_global_passwd
	.long	4
	.long	64
	.long	.LC161
	.long	.LC141
	.long	0
	.long	.LASANLOC27
	.long	do_vhost
	.long	4
	.long	64
	.long	.LC162
	.long	.LC141
	.long	0
	.long	.LASANLOC28
	.long	no_symlink_check
	.long	4
	.long	64
	.long	.LC163
	.long	.LC141
	.long	0
	.long	.LASANLOC29
	.long	no_log
	.long	4
	.long	64
	.long	.LC164
	.long	.LC141
	.long	0
	.long	.LASANLOC30
	.long	do_chroot
	.long	4
	.long	64
	.long	.LC165
	.long	.LC141
	.long	0
	.long	.LASANLOC31
	.long	data_dir
	.long	4
	.long	64
	.long	.LC23
	.long	.LC141
	.long	0
	.long	.LASANLOC32
	.long	dir
	.long	4
	.long	64
	.long	.LC20
	.long	.LC141
	.long	0
	.long	.LASANLOC33
	.long	port
	.long	2
	.long	64
	.long	.LC19
	.long	.LC141
	.long	0
	.long	.LASANLOC34
	.long	debug
	.long	4
	.long	64
	.long	.LC18
	.long	.LC141
	.long	0
	.long	.LASANLOC35
	.long	argv0
	.long	4
	.long	64
	.long	.LC166
	.long	.LC141
	.long	0
	.long	.LASANLOC36
	.long	.LC95
	.long	35
	.long	96
	.long	.LC167
	.long	.LC141
	.long	0
	.long	0
	.long	.LC116
	.long	11
	.long	64
	.long	.LC168
	.long	.LC141
	.long	0
	.long	0
	.long	.LC39
	.long	13
	.long	64
	.long	.LC169
	.long	.LC141
	.long	0
	.long	0
	.long	.LC83
	.long	19
	.long	64
	.long	.LC170
	.long	.LC141
	.long	0
	.long	0
	.long	.LC136
	.long	16
	.long	64
	.long	.LC171
	.long	.LC141
	.long	0
	.long	0
	.long	.LC79
	.long	3
	.long	64
	.long	.LC172
	.long	.LC141
	.long	0
	.long	0
	.long	.LC80
	.long	39
	.long	96
	.long	.LC173
	.long	.LC141
	.long	0
	.long	0
	.long	.LC2
	.long	70
	.long	128
	.long	.LC174
	.long	.LC141
	.long	0
	.long	0
	.long	.LC128
	.long	20
	.long	64
	.long	.LC175
	.long	.LC141
	.long	0
	.long	0
	.long	.LC131
	.long	24
	.long	64
	.long	.LC176
	.long	.LC141
	.long	0
	.long	0
	.long	.LC69
	.long	3
	.long	64
	.long	.LC177
	.long	.LC141
	.long	0
	.long	0
	.long	.LC35
	.long	5
	.long	64
	.long	.LC178
	.long	.LC141
	.long	0
	.long	0
	.long	.LC60
	.long	3
	.long	64
	.long	.LC179
	.long	.LC141
	.long	0
	.long	0
	.long	.LC76
	.long	16
	.long	64
	.long	.LC180
	.long	.LC141
	.long	0
	.long	0
	.long	.LC62
	.long	3
	.long	64
	.long	.LC181
	.long	.LC141
	.long	0
	.long	0
	.long	.LC82
	.long	2
	.long	64
	.long	.LC182
	.long	.LC141
	.long	0
	.long	0
	.long	.LC54
	.long	3
	.long	64
	.long	.LC183
	.long	.LC141
	.long	0
	.long	0
	.long	.LC123
	.long	12
	.long	64
	.long	.LC184
	.long	.LC141
	.long	0
	.long	0
	.long	.LC129
	.long	15
	.long	64
	.long	.LC185
	.long	.LC141
	.long	0
	.long	0
	.long	.LC36
	.long	8
	.long	64
	.long	.LC186
	.long	.LC141
	.long	0
	.long	0
	.long	.LC21
	.long	7
	.long	64
	.long	.LC187
	.long	.LC141
	.long	0
	.long	0
	.long	.LC32
	.long	16
	.long	64
	.long	.LC188
	.long	.LC141
	.long	0
	.long	0
	.long	.LC135
	.long	12
	.long	64
	.long	.LC189
	.long	.LC141
	.long	0
	.long	0
	.long	.LC55
	.long	5
	.long	64
	.long	.LC190
	.long	.LC141
	.long	0
	.long	0
	.long	.LC45
	.long	32
	.long	64
	.long	.LC191
	.long	.LC141
	.long	0
	.long	0
	.long	.LC103
	.long	26
	.long	64
	.long	.LC192
	.long	.LC141
	.long	0
	.long	0
	.long	.LC29
	.long	7
	.long	64
	.long	.LC193
	.long	.LC141
	.long	0
	.long	0
	.long	.LC7
	.long	219
	.long	256
	.long	.LC194
	.long	.LC141
	.long	0
	.long	0
	.long	.LC4
	.long	65
	.long	128
	.long	.LC195
	.long	.LC141
	.long	0
	.long	0
	.long	.LC107
	.long	29
	.long	64
	.long	.LC196
	.long	.LC141
	.long	0
	.long	0
	.long	.LC105
	.long	39
	.long	96
	.long	.LC197
	.long	.LC141
	.long	0
	.long	0
	.long	.LC75
	.long	20
	.long	64
	.long	.LC198
	.long	.LC141
	.long	0
	.long	0
	.long	.LC77
	.long	33
	.long	96
	.long	.LC199
	.long	.LC141
	.long	0
	.long	0
	.long	.LC115
	.long	15
	.long	64
	.long	.LC200
	.long	.LC141
	.long	0
	.long	0
	.long	.LC31
	.long	7
	.long	64
	.long	.LC201
	.long	.LC141
	.long	0
	.long	0
	.long	.LC40
	.long	15
	.long	64
	.long	.LC202
	.long	.LC141
	.long	0
	.long	0
	.long	.LC49
	.long	3
	.long	64
	.long	.LC203
	.long	.LC141
	.long	0
	.long	0
	.long	.LC56
	.long	4
	.long	64
	.long	.LC204
	.long	.LC141
	.long	0
	.long	0
	.long	.LC41
	.long	8
	.long	64
	.long	.LC205
	.long	.LC141
	.long	0
	.long	0
	.long	.LC118
	.long	2
	.long	64
	.long	.LC206
	.long	.LC141
	.long	0
	.long	0
	.long	.LC61
	.long	3
	.long	64
	.long	.LC207
	.long	.LC141
	.long	0
	.long	0
	.long	.LC30
	.long	9
	.long	64
	.long	.LC208
	.long	.LC141
	.long	0
	.long	0
	.long	.LC0
	.long	104
	.long	160
	.long	.LC209
	.long	.LC141
	.long	0
	.long	0
	.long	.LC84
	.long	2
	.long	64
	.long	.LC210
	.long	.LC141
	.long	0
	.long	0
	.long	.LC137
	.long	12
	.long	64
	.long	.LC211
	.long	.LC141
	.long	0
	.long	0
	.long	.LC121
	.long	4
	.long	64
	.long	.LC212
	.long	.LC141
	.long	0
	.long	0
	.long	.LC12
	.long	16
	.long	64
	.long	.LC213
	.long	.LC141
	.long	0
	.long	0
	.long	.LC134
	.long	15
	.long	64
	.long	.LC214
	.long	.LC141
	.long	0
	.long	0
	.long	.LC46
	.long	7
	.long	64
	.long	.LC215
	.long	.LC141
	.long	0
	.long	0
	.long	.LC47
	.long	11
	.long	64
	.long	.LC216
	.long	.LC141
	.long	0
	.long	0
	.long	.LC102
	.long	3
	.long	64
	.long	.LC217
	.long	.LC141
	.long	0
	.long	0
	.long	.LC127
	.long	13
	.long	64
	.long	.LC218
	.long	.LC141
	.long	0
	.long	0
	.long	.LC43
	.long	4
	.long	64
	.long	.LC219
	.long	.LC141
	.long	0
	.long	0
	.long	.LC98
	.long	37
	.long	96
	.long	.LC220
	.long	.LC141
	.long	0
	.long	0
	.long	.LC19
	.long	5
	.long	64
	.long	.LC221
	.long	.LC141
	.long	0
	.long	0
	.long	.LC25
	.long	10
	.long	64
	.long	.LC222
	.long	.LC141
	.long	0
	.long	0
	.long	.LC126
	.long	18
	.long	64
	.long	.LC223
	.long	.LC141
	.long	0
	.long	0
	.long	.LC109
	.long	23
	.long	64
	.long	.LC224
	.long	.LC141
	.long	0
	.long	0
	.long	.LC110
	.long	25
	.long	64
	.long	.LC225
	.long	.LC141
	.long	0
	.long	0
	.long	.LC140
	.long	13
	.long	64
	.long	.LC226
	.long	.LC141
	.long	0
	.long	0
	.long	.LC20
	.long	4
	.long	64
	.long	.LC227
	.long	.LC141
	.long	0
	.long	0
	.long	.LC50
	.long	26
	.long	64
	.long	.LC228
	.long	.LC141
	.long	0
	.long	0
	.long	.LC72
	.long	3
	.long	64
	.long	.LC229
	.long	.LC141
	.long	0
	.long	0
	.long	.LC88
	.long	39
	.long	96
	.long	.LC230
	.long	.LC141
	.long	0
	.long	0
	.long	.LC66
	.long	3
	.long	64
	.long	.LC231
	.long	.LC141
	.long	0
	.long	0
	.long	.LC63
	.long	3
	.long	64
	.long	.LC232
	.long	.LC141
	.long	0
	.long	0
	.long	.LC64
	.long	3
	.long	64
	.long	.LC233
	.long	.LC141
	.long	0
	.long	0
	.long	.LC113
	.long	72
	.long	128
	.long	.LC234
	.long	.LC141
	.long	0
	.long	0
	.long	.LC16
	.long	2
	.long	64
	.long	.LC235
	.long	.LC141
	.long	0
	.long	0
	.long	.LC120
	.long	2
	.long	64
	.long	.LC236
	.long	.LC141
	.long	0
	.long	0
	.long	.LC119
	.long	12
	.long	64
	.long	.LC237
	.long	.LC141
	.long	0
	.long	0
	.long	.LC78
	.long	38
	.long	96
	.long	.LC238
	.long	.LC141
	.long	0
	.long	0
	.long	.LC122
	.long	31
	.long	64
	.long	.LC239
	.long	.LC141
	.long	0
	.long	0
	.long	.LC5
	.long	37
	.long	96
	.long	.LC240
	.long	.LC141
	.long	0
	.long	0
	.long	.LC124
	.long	74
	.long	128
	.long	.LC241
	.long	.LC141
	.long	0
	.long	0
	.long	.LC17
	.long	5
	.long	64
	.long	.LC242
	.long	.LC141
	.long	0
	.long	0
	.long	.LC67
	.long	5
	.long	64
	.long	.LC243
	.long	.LC141
	.long	0
	.long	0
	.long	.LC22
	.long	9
	.long	64
	.long	.LC244
	.long	.LC141
	.long	0
	.long	0
	.long	.LC42
	.long	8
	.long	64
	.long	.LC245
	.long	.LC141
	.long	0
	.long	0
	.long	.LC65
	.long	5
	.long	64
	.long	.LC246
	.long	.LC141
	.long	0
	.long	0
	.long	.LC26
	.long	9
	.long	64
	.long	.LC247
	.long	.LC141
	.long	0
	.long	0
	.long	.LC85
	.long	22
	.long	64
	.long	.LC248
	.long	.LC141
	.long	0
	.long	0
	.long	.LC33
	.long	9
	.long	64
	.long	.LC249
	.long	.LC141
	.long	0
	.long	0
	.long	.LC48
	.long	1
	.long	64
	.long	.LC250
	.long	.LC141
	.long	0
	.long	0
	.long	.LC117
	.long	6
	.long	64
	.long	.LC251
	.long	.LC141
	.long	0
	.long	0
	.long	.LC125
	.long	79
	.long	128
	.long	.LC252
	.long	.LC141
	.long	0
	.long	0
	.long	.LC104
	.long	25
	.long	64
	.long	.LC253
	.long	.LC141
	.long	0
	.long	0
	.long	.LC99
	.long	25
	.long	64
	.long	.LC254
	.long	.LC141
	.long	0
	.long	0
	.long	.LC138
	.long	58
	.long	96
	.long	.LC255
	.long	.LC141
	.long	0
	.long	0
	.long	.LC94
	.long	35
	.long	96
	.long	.LC256
	.long	.LC141
	.long	0
	.long	0
	.long	.LC74
	.long	11
	.long	64
	.long	.LC257
	.long	.LC141
	.long	0
	.long	0
	.long	.LC9
	.long	39
	.long	96
	.long	.LC258
	.long	.LC141
	.long	0
	.long	0
	.long	.LC133
	.long	30
	.long	64
	.long	.LC259
	.long	.LC141
	.long	0
	.long	0
	.long	.LC70
	.long	3
	.long	64
	.long	.LC260
	.long	.LC141
	.long	0
	.long	0
	.long	.LC81
	.long	44
	.long	96
	.long	.LC261
	.long	.LC141
	.long	0
	.long	0
	.long	.LC53
	.long	3
	.long	64
	.long	.LC262
	.long	.LC141
	.long	0
	.long	0
	.long	.LC68
	.long	3
	.long	64
	.long	.LC263
	.long	.LC141
	.long	0
	.long	0
	.long	.LC57
	.long	3
	.long	64
	.long	.LC264
	.long	.LC141
	.long	0
	.long	0
	.long	.LC89
	.long	56
	.long	96
	.long	.LC265
	.long	.LC141
	.long	0
	.long	0
	.long	.LC139
	.long	38
	.long	96
	.long	.LC266
	.long	.LC141
	.long	0
	.long	0
	.long	.LC3
	.long	62
	.long	96
	.long	.LC267
	.long	.LC141
	.long	0
	.long	0
	.long	.LC92
	.long	33
	.long	96
	.long	.LC268
	.long	.LC141
	.long	0
	.long	0
	.long	.LC6
	.long	34
	.long	96
	.long	.LC269
	.long	.LC141
	.long	0
	.long	0
	.long	.LC93
	.long	43
	.long	96
	.long	.LC270
	.long	.LC141
	.long	0
	.long	0
	.long	.LC132
	.long	36
	.long	96
	.long	.LC271
	.long	.LC141
	.long	0
	.long	0
	.long	.LC97
	.long	33
	.long	96
	.long	.LC272
	.long	.LC141
	.long	0
	.long	0
	.long	.LC90
	.long	8
	.long	64
	.long	.LC273
	.long	.LC141
	.long	0
	.long	0
	.long	.LC23
	.long	9
	.long	64
	.long	.LC274
	.long	.LC141
	.long	0
	.long	0
	.long	.LC58
	.long	5
	.long	64
	.long	.LC275
	.long	.LC141
	.long	0
	.long	0
	.long	.LC10
	.long	5
	.long	64
	.long	.LC276
	.long	.LC141
	.long	0
	.long	0
	.long	.LC114
	.long	20
	.long	64
	.long	.LC277
	.long	.LC141
	.long	0
	.long	0
	.long	.LC111
	.long	10
	.long	64
	.long	.LC278
	.long	.LC141
	.long	0
	.long	0
	.long	.LC86
	.long	22
	.long	64
	.long	.LC279
	.long	.LC141
	.long	0
	.long	0
	.long	.LC34
	.long	10
	.long	64
	.long	.LC280
	.long	.LC141
	.long	0
	.long	0
	.long	.LC130
	.long	30
	.long	64
	.long	.LC281
	.long	.LC141
	.long	0
	.long	0
	.long	.LC44
	.long	8
	.long	64
	.long	.LC282
	.long	.LC141
	.long	0
	.long	0
	.long	.LC27
	.long	11
	.long	64
	.long	.LC283
	.long	.LC141
	.long	0
	.long	0
	.long	.LC87
	.long	36
	.long	96
	.long	.LC284
	.long	.LC141
	.long	0
	.long	0
	.long	.LC91
	.long	25
	.long	64
	.long	.LC285
	.long	.LC141
	.long	0
	.long	0
	.long	.LC51
	.long	3
	.long	64
	.long	.LC286
	.long	.LC141
	.long	0
	.long	0
	.long	.LC71
	.long	3
	.long	64
	.long	.LC287
	.long	.LC141
	.long	0
	.long	0
	.long	.LC38
	.long	8
	.long	64
	.long	.LC288
	.long	.LC141
	.long	0
	.long	0
	.long	.LC52
	.long	3
	.long	64
	.long	.LC289
	.long	.LC141
	.long	0
	.long	0
	.long	.LC59
	.long	3
	.long	64
	.long	.LC290
	.long	.LC141
	.long	0
	.long	0
	.long	.LC37
	.long	6
	.long	64
	.long	.LC291
	.long	.LC141
	.long	0
	.long	0
	.long	.LC28
	.long	5
	.long	64
	.long	.LC292
	.long	.LC141
	.long	0
	.long	0
	.long	.LC13
	.long	31
	.long	64
	.long	.LC293
	.long	.LC141
	.long	0
	.long	0
	.long	.LC14
	.long	36
	.long	96
	.long	.LC294
	.long	.LC141
	.long	0
	.long	0
	.long	.LC108
	.long	34
	.long	96
	.long	.LC295
	.long	.LC141
	.long	0
	.long	0
	.long	.LC24
	.long	8
	.long	64
	.long	.LC296
	.long	.LC141
	.long	0
	.long	0
	.long	.LC112
	.long	67
	.long	128
	.long	.LC297
	.long	.LC141
	.long	0
	.long	0
	.long	.LC18
	.long	6
	.long	64
	.long	.LC298
	.long	.LC141
	.long	0
	.long	0
	.section	.text.exit,"ax",@progbits
	.p2align 4,,15
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB38:
	.cfi_startproc
	subl	$20, %esp
	.cfi_def_cfa_offset 24
	pushl	$168
	.cfi_def_cfa_offset 28
	pushl	$.LASAN0
	.cfi_def_cfa_offset 32
	call	__asan_unregister_globals
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE38:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.fini_array.00099,"aw"
	.align 4
	.long	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.startup
	.p2align 4,,15
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB39:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	__asan_init
	call	__asan_version_mismatch_check_v6
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$168
	.cfi_def_cfa_offset 28
	pushl	$.LASAN0
	.cfi_def_cfa_offset 32
	call	__asan_register_globals
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE39:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.init_array.00099,"aw"
	.align 4
	.long	_GLOBAL__sub_I_00099_1_terminate
	.ident	"GCC: (GNU) 6.2.0"
	.section	.note.GNU-stack,"",@progbits
