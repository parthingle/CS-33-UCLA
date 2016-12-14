	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
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
	.section	.rodata.str1.4
	.align 4
.LC2:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 4
.LC3:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 4
.LC4:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LFB25:
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
	xorl	%ebx, %ebx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	numthrottles, %eax
	testl	%eax, %eax
	jg	.L25
	jmp	.L14
	.p2align 4,,10
	.p2align 3
.L37:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	%eax
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	pushl	(%ecx)
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$.LC2
	.cfi_def_cfa_offset 76
	pushl	$5
	.cfi_def_cfa_offset 80
.L34:
	call	syslog
	addl	throttles, %esi
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	movl	12(%esi), %edx
	movl	%esi, %ecx
.L10:
	movl	8(%ecx), %eax
	cmpl	%edx, %eax
	jle	.L11
	movl	20(%ecx), %esi
	testl	%esi, %esi
	je	.L11
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	%eax
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	pushl	(%ecx)
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$.LC4
	.cfi_def_cfa_offset 76
	pushl	$5
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	.p2align 4,,10
	.p2align 3
.L11:
	addl	$1, %ebx
	cmpl	%ebx, numthrottles
	jle	.L14
.L25:
	leal	(%ebx,%ebx,2), %esi
	movl	throttles, %ecx
	sall	$3, %esi
	addl	%esi, %ecx
	movl	16(%ecx), %edi
	movl	12(%ecx), %edx
	movl	$0, 16(%ecx)
	movl	%edi, %eax
	shrl	$31, %eax
	addl	%edi, %eax
	sarl	%eax
	leal	(%eax,%edx,2), %edi
	movl	$1431655766, %edx
	movl	%edi, %eax
	sarl	$31, %edi
	imull	%edx
	movl	4(%ecx), %eax
	subl	%edi, %edx
	cmpl	%eax, %edx
	movl	%edx, 12(%ecx)
	jle	.L10
	movl	20(%ecx), %edi
	testl	%edi, %edi
	je	.L11
	leal	(%eax,%eax), %ebp
	cmpl	%ebp, %edx
	jg	.L37
	subl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	%eax
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	pushl	(%ecx)
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$.LC3
	.cfi_def_cfa_offset 76
	pushl	$6
	.cfi_def_cfa_offset 80
	jmp	.L34
	.p2align 4,,10
	.p2align 3
.L14:
	.cfi_restore_state
	movl	max_connects, %eax
	testl	%eax, %eax
	jle	.L6
	movl	connects, %esi
	leal	(%eax,%eax,2), %eax
	movl	throttles, %ebp
	sall	$5, %eax
	addl	%esi, %eax
	movl	%eax, 12(%esp)
	jmp	.L16
	.p2align 4,,10
	.p2align 3
.L17:
	addl	$96, %esi
	cmpl	%esi, 12(%esp)
	je	.L6
.L16:
	movl	(%esi), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L17
	movl	52(%esi), %eax
	movl	$-1, 56(%esi)
	testl	%eax, %eax
	jle	.L17
	leal	12(%esi,%eax,4), %edi
	leal	12(%esi), %ebx
	movl	$-1, %ecx
	movl	%edi, 8(%esp)
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L38:
	movl	56(%esi), %ecx
.L20:
	movl	(%ebx), %eax
	leal	(%eax,%eax,2), %eax
	leal	0(%ebp,%eax,8), %edi
	movl	4(%edi), %eax
	cltd
	idivl	20(%edi)
	cmpl	$-1, %ecx
	je	.L35
	cmpl	%ecx, %eax
	cmovg	%ecx, %eax
.L35:
	addl	$4, %ebx
	cmpl	8(%esp), %ebx
	movl	%eax, 56(%esi)
	jne	.L38
	addl	$96, %esi
	cmpl	%esi, 12(%esp)
	jne	.L16
.L6:
	addl	$28, %esp
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
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata.str1.4
	.align 4
.LC5:
	.string	"%s: no value required for %s option\n"
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LFB14:
	.cfi_startproc
	testl	%edx, %edx
	jne	.L44
	rep ret
.L44:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC5
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata.str1.4
	.align 4
.LC6:
	.string	"%s: value required for %s option\n"
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LFB13:
	.cfi_startproc
	testl	%edx, %edx
	je	.L50
	rep ret
.L50:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC6
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata.str1.4
	.align 4
.LC7:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.section	.text.unlikely,"ax",@progbits
	.type	usage, @function
usage:
.LFB11:
	.cfi_startproc
	subl	$16, %esp
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC7
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LFB30:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	movl	16(%esp), %eax
	cmpl	$3, (%eax)
	movl	$0, 72(%eax)
	je	.L56
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L56:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	movl	$2, (%eax)
	pushl	$1
	.cfi_def_cfa_offset 24
	pushl	%eax
	.cfi_def_cfa_offset 28
	movl	8(%eax), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	addl	$12, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.4
	.align 4
.LC8:
	.string	"up %ld seconds, stats for %ld seconds:"
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LFB34:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$24, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L61
.L58:
	movl	(%eax), %eax
	movl	$1, %ecx
	movl	%eax, %edx
	movl	%eax, %ebx
	subl	start_time, %edx
	subl	stats_time, %ebx
	movl	%eax, stats_time
	cmove	%ecx, %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 36
	pushl	%edx
	.cfi_def_cfa_offset 40
	pushl	$.LC8
	.cfi_def_cfa_offset 44
	pushl	$6
	.cfi_def_cfa_offset 48
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
	addl	$40, %esp
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L61:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	$0
	.cfi_def_cfa_offset 44
	leal	20(%esp), %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	gettimeofday
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	movl	%ebx, %eax
	jmp	.L58
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
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
	movl	(%eax), %esi
	movl	%eax, %ebx
	xorl	%eax, %eax
	call	logstats
	movl	%esi, (%ebx)
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
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
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC9:
	.string	"/tmp"
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
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
	movl	(%eax), %esi
	movl	watchdog_flag, %eax
	testl	%eax, %eax
	je	.L70
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	movl	$0, watchdog_flag
	pushl	$360
	.cfi_def_cfa_offset 32
	call	alarm
	movl	%esi, (%ebx)
	addl	$20, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
.L70:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -12
	.cfi_offset 6, -8
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$.LC9
	.cfi_def_cfa_offset 32
	call	chdir
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC10:
	.string	"child wait - %m"
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	xorl	%edi, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movl	(%eax), %ebp
	leal	12(%esp), %ebx
	movl	%eax, %esi
	.p2align 4,,10
	.p2align 3
.L72:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	$1
	.cfi_def_cfa_offset 56
	pushl	%ebx
	.cfi_def_cfa_offset 60
	pushl	$-1
	.cfi_def_cfa_offset 64
	call	waitpid
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L73
	js	.L88
	movl	hs, %edx
	testl	%edx, %edx
	je	.L72
	movl	20(%edx), %eax
	subl	$1, %eax
	cmovs	%edi, %eax
	movl	%eax, 20(%edx)
	jmp	.L72
	.p2align 4,,10
	.p2align 3
.L88:
	movl	(%esi), %eax
	cmpl	$4, %eax
	je	.L72
	cmpl	$11, %eax
	je	.L72
	cmpl	$10, %eax
	je	.L73
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC10
	.cfi_def_cfa_offset 60
	pushl	$3
	.cfi_def_cfa_offset 64
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 48
.L73:
	movl	%ebp, (%esi)
	addl	$28, %esp
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
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata.str1.4
	.align 4
.LC11:
	.string	"out of memory copying a string"
	.align 4
.LC12:
	.string	"%s: out of memory copying a string\n"
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
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
	je	.L92
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
.L92:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC11
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC12
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.section	.rodata.str1.1
.LC13:
	.string	"r"
.LC14:
	.string	" \t\n\r"
.LC15:
	.string	"debug"
.LC16:
	.string	"port"
.LC17:
	.string	"dir"
.LC18:
	.string	"chroot"
.LC19:
	.string	"nochroot"
.LC20:
	.string	"data_dir"
.LC21:
	.string	"symlink"
.LC22:
	.string	"nosymlink"
.LC23:
	.string	"symlinks"
.LC24:
	.string	"nosymlinks"
.LC25:
	.string	"user"
.LC26:
	.string	"cgipat"
.LC27:
	.string	"cgilimit"
.LC28:
	.string	"urlpat"
.LC29:
	.string	"noemptyreferers"
.LC30:
	.string	"localpat"
.LC31:
	.string	"throttles"
.LC32:
	.string	"host"
.LC33:
	.string	"logfile"
.LC34:
	.string	"vhost"
.LC35:
	.string	"novhost"
.LC36:
	.string	"globalpasswd"
.LC37:
	.string	"noglobalpasswd"
.LC38:
	.string	"pidfile"
.LC39:
	.string	"charset"
.LC40:
	.string	"p3p"
.LC41:
	.string	"max_age"
	.section	.rodata.str1.4
	.align 4
.LC42:
	.string	"%s: unknown config option '%s'\n"
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
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
	subl	$148, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC13
	.cfi_def_cfa_offset 172
	pushl	%eax
	.cfi_def_cfa_offset 176
	call	fopen
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L140
	movl	$8388627, %ebp
.L94:
	subl	$4, %esp
	.cfi_def_cfa_offset 164
	pushl	16(%esp)
	.cfi_def_cfa_offset 168
	pushl	$1000
	.cfi_def_cfa_offset 172
	leal	40(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 176
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L145
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$35
	.cfi_def_cfa_offset 172
	leal	40(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 176
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L95
	movb	$0, (%eax)
.L95:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC14
	.cfi_def_cfa_offset 172
	leal	40(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 176
	call	strspn
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	leal	28(%esp), %ecx
	leal	(%ecx,%eax), %esi
	cmpb	$0, (%esi)
	jne	.L136
	jmp	.L94
	.p2align 4,,10
	.p2align 3
.L97:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$61
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L131
	leal	1(%eax), %edi
	movb	$0, (%eax)
.L99:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC15
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L146
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC16
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L147
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC17
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L148
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC18
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L149
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC19
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L150
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC20
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L151
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC21
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L143
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC22
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L144
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC23
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L143
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC24
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L144
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC25
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L152
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC26
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L153
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC27
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L154
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC28
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L155
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC29
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L156
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC30
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L157
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC31
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L158
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC32
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L159
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC33
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L160
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC34
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L161
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC35
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L162
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC36
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L163
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC37
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L164
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC38
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L165
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC39
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L166
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC40
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L167
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC41
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	jne	.L127
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	%edi
	.cfi_def_cfa_offset 176
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movl	%eax, max_age
	.p2align 4,,10
	.p2align 3
.L101:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC14
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strspn
	leal	(%ebx,%eax), %esi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	cmpb	$0, (%esi)
	je	.L94
.L136:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC14
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	strcspn
	leal	(%esi,%eax), %ebx
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movzbl	(%ebx), %eax
	subl	$9, %eax
	cmpb	$23, %al
	ja	.L97
	.p2align 4,,10
	.p2align 3
.L142:
	btl	%eax, %ebp
	jnc	.L97
	addl	$1, %ebx
	movzbl	(%ebx), %eax
	movb	$0, -1(%ebx)
	subl	$9, %eax
	cmpb	$23, %al
	jbe	.L142
	jmp	.L97
.L146:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, debug
	jmp	.L101
.L147:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	%edi
	.cfi_def_cfa_offset 176
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movw	%ax, port
	jmp	.L101
.L131:
	xorl	%edi, %edi
	jmp	.L99
.L148:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, dir
	jmp	.L101
.L149:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L101
.L150:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L101
.L143:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L101
.L151:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, data_dir
	jmp	.L101
.L144:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L101
.L152:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, user
	jmp	.L101
.L154:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	%edi
	.cfi_def_cfa_offset 176
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movl	%eax, cgi_limit
	jmp	.L101
.L153:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, cgi_pattern
	jmp	.L101
.L145:
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	24(%esp)
	.cfi_def_cfa_offset 176
	call	fclose
	addl	$156, %esp
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
.L157:
	.cfi_def_cfa_offset 160
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, local_pattern
	jmp	.L101
.L156:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, no_empty_referers
	jmp	.L101
.L155:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, url_pattern
	jmp	.L101
.L127:
	pushl	%esi
	.cfi_remember_state
	.cfi_def_cfa_offset 164
	pushl	argv0
	.cfi_def_cfa_offset 168
	pushl	$.LC42
	.cfi_def_cfa_offset 172
	pushl	stderr
	.cfi_def_cfa_offset 176
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L167:
	.cfi_restore_state
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, p3p
	jmp	.L101
.L140:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	perror
	movl	$1, (%esp)
	call	exit
.L158:
	.cfi_restore_state
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, throttlefile
	jmp	.L101
.L166:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, charset
	jmp	.L101
.L165:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, pidfile
	jmp	.L101
.L164:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, do_global_passwd
	jmp	.L101
.L163:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, do_global_passwd
	jmp	.L101
.L162:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, do_vhost
	jmp	.L101
.L161:
	movl	%edi, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, do_vhost
	jmp	.L101
.L160:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, logfile
	jmp	.L101
.L159:
	movl	%edi, %edx
	movl	%esi, %eax
	call	value_required
	movl	%edi, %eax
	call	e_strdup
	movl	%eax, hostname
	jmp	.L101
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata.str1.1
.LC43:
	.string	"nobody"
.LC44:
	.string	"iso-8859-1"
.LC45:
	.string	""
.LC46:
	.string	"-V"
.LC47:
	.string	"thttpd/2.27.0 Oct 3, 2014"
.LC48:
	.string	"-C"
.LC49:
	.string	"-p"
.LC50:
	.string	"-d"
.LC51:
	.string	"-r"
.LC52:
	.string	"-nor"
.LC53:
	.string	"-dd"
.LC54:
	.string	"-s"
.LC55:
	.string	"-nos"
.LC56:
	.string	"-u"
.LC57:
	.string	"-c"
.LC58:
	.string	"-t"
.LC59:
	.string	"-h"
.LC60:
	.string	"-l"
.LC61:
	.string	"-v"
.LC62:
	.string	"-nov"
.LC63:
	.string	"-g"
.LC64:
	.string	"-nog"
.LC65:
	.string	"-i"
.LC66:
	.string	"-T"
.LC67:
	.string	"-P"
.LC68:
	.string	"-M"
.LC69:
	.string	"-D"
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
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
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	cmpl	$1, %eax
	movl	$0, debug
	movl	%eax, 8(%esp)
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
	movl	$.LC43, user
	movl	$.LC44, charset
	movl	$.LC45, p3p
	movl	$-1, max_age
	jle	.L200
	movl	4(%edx), %ebx
	movl	$1, %ebp
	cmpb	$45, (%ebx)
	je	.L207
	jmp	.L171
	.p2align 4,,10
	.p2align 3
.L217:
	leal	1(%ebp), %esi
	cmpl	%esi, 8(%esp)
	jg	.L215
	movl	$.LC49, %edi
	movl	$3, %ecx
	movl	%ebx, %esi
	repz cmpsb
	je	.L177
.L176:
	movl	$.LC50, %edi
	movl	$3, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L177
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L177
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, dir
.L175:
	addl	$1, %ebp
	cmpl	%ebp, 8(%esp)
	jle	.L169
.L218:
	movl	(%edx,%ebp,4), %ebx
	cmpb	$45, (%ebx)
	jne	.L171
.L207:
	movl	$3, %ecx
	movl	%ebx, %esi
	movl	$.LC46, %edi
	repz cmpsb
	je	.L216
	movl	$.LC48, %edi
	movl	$3, %ecx
	movl	%ebx, %esi
	repz cmpsb
	je	.L217
	movl	$.LC49, %edi
	movl	$3, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L176
	leal	1(%ebp), %esi
	cmpl	%esi, 8(%esp)
	jle	.L177
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	(%edx,%esi,4)
	.cfi_def_cfa_offset 64
	movl	%esi, %ebp
	addl	$1, %ebp
	movl	%edx, 28(%esp)
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movw	%ax, port
	movl	12(%esp), %edx
	cmpl	%ebp, 8(%esp)
	jg	.L218
.L169:
	cmpl	%ebp, 8(%esp)
	jne	.L171
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
.L177:
	.cfi_restore_state
	movl	$.LC51, %edi
	movl	$3, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L178
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L178:
	movl	$.LC52, %edi
	movl	$5, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L179
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L215:
	movl	(%edx,%esi,4), %eax
	movl	%edx, 12(%esp)
	movl	%esi, %ebp
	call	read_config
	movl	12(%esp), %edx
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L179:
	movl	$.LC53, %edi
	movl	$4, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L180
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L180
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, data_dir
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L180:
	movl	$.LC54, %edi
	movl	$3, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L181
	movl	$0, no_symlink_check
	jmp	.L175
	.p2align 4,,10
	.p2align 3
.L181:
	movl	$.LC55, %edi
	movl	$5, %ecx
	movl	%ebx, %esi
	repz cmpsb
	je	.L219
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC56
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L183
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L183
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, user
	jmp	.L175
.L219:
	movl	$1, no_symlink_check
	jmp	.L175
.L183:
	movl	%edx, 12(%esp)
	pushl	%edi
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	$.LC57
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L184
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L184
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, cgi_pattern
	jmp	.L175
.L184:
	movl	%edx, 12(%esp)
	pushl	%esi
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	$.LC58
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	je	.L220
	movl	%edx, 12(%esp)
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC59
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L187
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L188
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, hostname
	jmp	.L175
.L220:
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L186
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, throttlefile
	jmp	.L175
.L186:
	movl	%edx, 12(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	pushl	$.LC59
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L187
.L188:
	movl	%edx, 12(%esp)
	pushl	%eax
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
	movl	12(%esp), %edx
	jne	.L189
	movl	$1, do_vhost
	jmp	.L175
.L187:
	movl	%edx, 12(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	pushl	$.LC60
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L188
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L188
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, logfile
	jmp	.L175
.L189:
	movl	%edx, 12(%esp)
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
	movl	12(%esp), %edx
	je	.L221
	movl	%edx, 12(%esp)
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
	movl	12(%esp), %edx
	jne	.L191
	movl	$1, do_global_passwd
	jmp	.L175
.L221:
	movl	$0, do_vhost
	jmp	.L175
.L200:
	movl	$1, %ebp
	jmp	.L169
.L191:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC64
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L192
	movl	$0, do_global_passwd
	jmp	.L175
.L216:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$.LC47
	.cfi_def_cfa_offset 64
	call	puts
	movl	$0, (%esp)
	call	exit
.L192:
	.cfi_restore_state
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC65
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	je	.L222
	movl	%edx, 12(%esp)
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
	movl	12(%esp), %edx
	jne	.L195
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L194
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, charset
	jmp	.L175
.L222:
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L194
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, pidfile
	jmp	.L175
.L194:
	movl	%edx, 12(%esp)
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
	movl	12(%esp), %edx
	je	.L197
.L196:
	movl	%edx, 12(%esp)
	pushl	%esi
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	$.LC68
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L197
	leal	1(%ebp), %esi
	cmpl	%esi, 8(%esp)
	jle	.L197
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	(%edx,%esi,4)
	.cfi_def_cfa_offset 64
	movl	%esi, %ebp
	movl	%edx, 28(%esp)
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	%eax, max_age
	movl	12(%esp), %edx
	jmp	.L175
.L195:
	movl	%edx, 12(%esp)
	pushl	%edi
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	$.LC67
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L196
	leal	1(%ebp), %eax
	cmpl	%eax, 8(%esp)
	jle	.L197
	movl	(%edx,%eax,4), %ecx
	movl	%eax, %ebp
	movl	%ecx, p3p
	jmp	.L175
.L197:
	movl	%edx, 12(%esp)
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC69
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L171
	movl	$1, debug
	movl	12(%esp), %edx
	jmp	.L175
.L171:
	call	usage
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.section	.rodata.str1.1
.LC70:
	.string	"%.80s - %m"
.LC71:
	.string	" %4900[^ \t] %ld-%ld"
.LC72:
	.string	" %4900[^ \t] %ld"
	.section	.rodata.str1.4
	.align 4
.LC73:
	.string	"unparsable line in %.80s - %.80s"
	.align 4
.LC74:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.section	.rodata.str1.1
.LC75:
	.string	"|/"
	.section	.rodata.str1.4
	.align 4
.LC76:
	.string	"out of memory allocating a throttletab"
	.align 4
.LC77:
	.string	"%s: out of memory allocating a throttletab\n"
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
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
	subl	$10052, %esp
	.cfi_def_cfa_offset 10072
	movl	%eax, 20(%esp)
	pushl	$.LC13
	.cfi_def_cfa_offset 10076
	pushl	%eax
	.cfi_def_cfa_offset 10080
	call	fopen
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	testl	%eax, %eax
	je	.L267
	subl	$8, %esp
	.cfi_def_cfa_offset 10072
	movl	%eax, %esi
	pushl	$0
	.cfi_def_cfa_offset 10076
	leal	36(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 10080
	call	gettimeofday
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	leal	32(%esp), %ebx
	leal	16(%esp), %edi
	.p2align 4,,10
	.p2align 3
.L225:
	subl	$4, %esp
	.cfi_def_cfa_offset 10068
	pushl	%esi
	.cfi_def_cfa_offset 10072
	pushl	$5000
	.cfi_def_cfa_offset 10076
	pushl	%ebx
	.cfi_def_cfa_offset 10080
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	testl	%eax, %eax
	je	.L268
	subl	$8, %esp
	.cfi_def_cfa_offset 10072
	pushl	$35
	.cfi_def_cfa_offset 10076
	pushl	%ebx
	.cfi_def_cfa_offset 10080
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	testl	%eax, %eax
	je	.L226
	movb	$0, (%eax)
.L226:
	movl	%ebx, %eax
.L227:
	movl	(%eax), %ecx
	addl	$4, %eax
	leal	-16843009(%ecx), %edx
	notl	%ecx
	andl	%ecx, %edx
	andl	$-2139062144, %edx
	je	.L227
	movl	%edx, %ecx
	shrl	$16, %ecx
	testl	$32896, %edx
	cmove	%ecx, %edx
	leal	2(%eax), %ecx
	cmove	%ecx, %eax
	movl	%edx, %ecx
	addb	%dl, %cl
	sbbl	$3, %eax
	subl	%ebx, %eax
	cmpl	$0, %eax
	jle	.L229
	subl	$1, %eax
	movzbl	32(%esp,%eax), %ecx
	leal	-9(%ecx), %edx
	cmpb	$23, %dl
	jbe	.L269
	.p2align 4,,10
	.p2align 3
.L230:
	subl	$12, %esp
	.cfi_def_cfa_offset 10076
	pushl	%edi
	.cfi_def_cfa_offset 10080
	leal	36(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 10084
	leal	5052(%esp), %ebp
	pushl	%ebp
	.cfi_def_cfa_offset 10088
	pushl	$.LC71
	.cfi_def_cfa_offset 10092
	pushl	%ebx
	.cfi_def_cfa_offset 10096
	call	__isoc99_sscanf
	addl	$32, %esp
	.cfi_def_cfa_offset 10064
	cmpl	$3, %eax
	je	.L232
	pushl	%edi
	.cfi_def_cfa_offset 10068
	pushl	%ebp
	.cfi_def_cfa_offset 10072
	pushl	$.LC72
	.cfi_def_cfa_offset 10076
	pushl	%ebx
	.cfi_def_cfa_offset 10080
	call	__isoc99_sscanf
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	cmpl	$2, %eax
	jne	.L236
	movl	$0, 20(%esp)
	.p2align 4,,10
	.p2align 3
.L232:
	cmpb	$47, 5032(%esp)
	jne	.L238
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L239:
	leal	2(%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10072
	addl	$1, %eax
	pushl	%edx
	.cfi_def_cfa_offset 10076
	pushl	%eax
	.cfi_def_cfa_offset 10080
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
.L238:
	subl	$8, %esp
	.cfi_def_cfa_offset 10072
	pushl	$.LC75
	.cfi_def_cfa_offset 10076
	pushl	%ebp
	.cfi_def_cfa_offset 10080
	call	strstr
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	testl	%eax, %eax
	jne	.L239
	movl	numthrottles, %edx
	movl	maxthrottles, %eax
	cmpl	%eax, %edx
	jl	.L240
	testl	%eax, %eax
	jne	.L241
	subl	$12, %esp
	.cfi_def_cfa_offset 10076
	movl	$100, maxthrottles
	pushl	$2400
	.cfi_def_cfa_offset 10080
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	movl	%eax, throttles
.L242:
	testl	%eax, %eax
	je	.L243
	movl	numthrottles, %edx
.L244:
	leal	(%edx,%edx,2), %edx
	leal	(%eax,%edx,8), %edx
	movl	%ebp, %eax
	movl	%edx, 8(%esp)
	call	e_strdup
	movl	8(%esp), %edx
	movl	%eax, (%edx)
	movl	numthrottles, %eax
	movl	throttles, %edx
	leal	(%eax,%eax,2), %ecx
	addl	$1, %eax
	movl	%eax, numthrottles
	leal	(%edx,%ecx,8), %edx
	movl	16(%esp), %ecx
	movl	$0, 12(%edx)
	movl	$0, 16(%edx)
	movl	%ecx, 4(%edx)
	movl	20(%esp), %ecx
	movl	$0, 20(%edx)
	movl	%ecx, 8(%edx)
	jmp	.L225
	.p2align 4,,10
	.p2align 3
.L269:
	movl	$8388627, %ebp
	movl	$8388627, %ecx
	btl	%edx, %ebp
	jc	.L260
	jmp	.L230
	.p2align 4,,10
	.p2align 3
.L271:
	btl	%edx, %ecx
	jnc	.L230
.L260:
	testl	%eax, %eax
	movb	$0, (%ebx,%eax)
	je	.L225
	subl	$1, %eax
	movzbl	(%ebx,%eax), %edx
	subl	$9, %edx
	cmpb	$23, %dl
	ja	.L230
	jmp	.L271
.L236:
	pushl	%ebx
	.cfi_def_cfa_offset 10068
	movl	16(%esp), %ebp
	pushl	%ebp
	.cfi_def_cfa_offset 10072
	pushl	$.LC73
	.cfi_def_cfa_offset 10076
	pushl	$2
	.cfi_def_cfa_offset 10080
	call	syslog
	movl	%ebx, (%esp)
	pushl	%ebp
	.cfi_def_cfa_offset 10084
	pushl	argv0
	.cfi_def_cfa_offset 10088
	pushl	$.LC74
	.cfi_def_cfa_offset 10092
	pushl	stderr
	.cfi_def_cfa_offset 10096
	call	fprintf
	addl	$32, %esp
	.cfi_def_cfa_offset 10064
	jmp	.L225
.L241:
	leal	(%eax,%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10072
	leal	(%edx,%eax,4), %eax
	movl	%edx, maxthrottles
	sall	$3, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10076
	pushl	throttles
	.cfi_def_cfa_offset 10080
	call	realloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	movl	%eax, throttles
	jmp	.L242
.L240:
	movl	throttles, %eax
	jmp	.L244
.L268:
	subl	$12, %esp
	.cfi_def_cfa_offset 10076
	pushl	%esi
	.cfi_def_cfa_offset 10080
	call	fclose
	addl	$10060, %esp
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
.L270:
	.cfi_def_cfa_offset 10064
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	pushl	%edx
	.cfi_def_cfa_offset 10068
	pushl	%edx
	.cfi_def_cfa_offset 10072
	leal	5041(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 10076
	pushl	%ebp
	.cfi_def_cfa_offset 10080
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10064
	jmp	.L238
.L229:
	jne	.L230
	jmp	.L225
.L243:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 10068
	pushl	%eax
	.cfi_def_cfa_offset 10072
	pushl	$.LC76
	.cfi_def_cfa_offset 10076
	pushl	$2
	.cfi_def_cfa_offset 10080
	call	syslog
	addl	$12, %esp
	.cfi_def_cfa_offset 10068
	pushl	argv0
	.cfi_def_cfa_offset 10072
	pushl	$.LC77
	.cfi_def_cfa_offset 10076
	pushl	stderr
	.cfi_def_cfa_offset 10080
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L267:
	.cfi_restore_state
	pushl	%ecx
	.cfi_def_cfa_offset 10068
	movl	16(%esp), %edi
	pushl	%edi
	.cfi_def_cfa_offset 10072
	pushl	$.LC70
	.cfi_def_cfa_offset 10076
	pushl	$2
	.cfi_def_cfa_offset 10080
	call	syslog
	movl	%edi, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata.str1.1
.LC78:
	.string	"-"
.LC79:
	.string	"re-opening logfile"
.LC80:
	.string	"a"
.LC81:
	.string	"re-opening %.80s - %m"
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LFB8:
	.cfi_startproc
	movl	no_log, %eax
	testl	%eax, %eax
	jne	.L287
	movl	hs, %ecx
	testl	%ecx, %ecx
	je	.L287
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	logfile, %esi
	testl	%esi, %esi
	je	.L272
	movl	$.LC78, %edi
	movl	$2, %ecx
	repz cmpsb
	jne	.L288
.L272:
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
.L287:
	rep ret
	.p2align 4,,10
	.p2align 3
.L288:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -12
	.cfi_offset 7, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC79
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	popl	%ecx
	.cfi_def_cfa_offset 28
	popl	%esi
	.cfi_def_cfa_offset 24
	pushl	$.LC80
	.cfi_def_cfa_offset 28
	pushl	logfile
	.cfi_def_cfa_offset 32
	call	fopen
	movl	logfile, %edi
	movl	%eax, %esi
	popl	%eax
	.cfi_def_cfa_offset 28
	popl	%edx
	.cfi_def_cfa_offset 24
	pushl	$384
	.cfi_def_cfa_offset 28
	pushl	%edi
	.cfi_def_cfa_offset 32
	call	chmod
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%esi, %esi
	je	.L276
	testl	%eax, %eax
	jne	.L276
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%esi
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
	pushl	%esi
	.cfi_def_cfa_offset 28
	pushl	hs
	.cfi_def_cfa_offset 32
	call	httpd_set_logfp
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	jmp	.L287
	.p2align 4,,10
	.p2align 3
.L276:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	%edi
	.cfi_def_cfa_offset 24
	pushl	$.LC81
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	jmp	.L272
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata.str1.1
.LC82:
	.string	"too many connections!"
	.section	.rodata.str1.4
	.align 4
.LC83:
	.string	"the connects free list is messed up"
	.align 4
.LC84:
	.string	"out of memory allocating an httpd_conn"
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LFB19:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	movl	%eax, %edi
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edx, %esi
	subl	$16, %esp
	.cfi_def_cfa_offset 32
	movl	num_connects, %eax
.L298:
	cmpl	%eax, max_connects
	jle	.L308
	movl	first_free_connect, %eax
	cmpl	$-1, %eax
	je	.L292
	leal	(%eax,%eax,2), %ebx
	sall	$5, %ebx
	addl	connects, %ebx
	movl	(%ebx), %edx
	testl	%edx, %edx
	jne	.L292
	movl	8(%ebx), %eax
	testl	%eax, %eax
	je	.L309
.L294:
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	%esi
	.cfi_def_cfa_offset 44
	pushl	hs
	.cfi_def_cfa_offset 48
	call	httpd_get_conn
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L297
	cmpl	$2, %eax
	jne	.L310
	movl	$1, %eax
.L289:
	addl	$16, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popl	%ebx
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
.L310:
	.cfi_restore_state
	movl	4(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	movl	$1, (%ebx)
	movl	$-1, 4(%ebx)
	addl	$1, num_connects
	movl	%eax, first_free_connect
	movl	(%edi), %eax
	movl	$0, 72(%ebx)
	movl	$0, 76(%ebx)
	movl	%eax, 68(%ebx)
	movl	8(%ebx), %eax
	movl	$0, 92(%ebx)
	movl	$0, 52(%ebx)
	pushl	448(%eax)
	.cfi_def_cfa_offset 48
	call	httpd_set_ndelay
	movl	8(%ebx), %eax
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	$0
	.cfi_def_cfa_offset 40
	pushl	%ebx
	.cfi_def_cfa_offset 44
	pushl	448(%eax)
	.cfi_def_cfa_offset 48
	call	fdwatch_add_fd
	addl	$1, stats_connections
	movl	num_connects, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	cmpl	stats_simultaneous, %eax
	jle	.L298
	movl	%eax, stats_simultaneous
	jmp	.L298
	.p2align 4,,10
	.p2align 3
.L297:
	movl	%eax, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%edi
	.cfi_def_cfa_offset 48
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	movl	12(%esp), %eax
	addl	$16, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popl	%ebx
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
.L309:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	$456
	.cfi_def_cfa_offset 48
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	movl	%eax, 8(%ebx)
	je	.L311
	movl	$0, (%eax)
	addl	$1, httpd_conn_count
	jmp	.L294
	.p2align 4,,10
	.p2align 3
.L308:
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	$.LC82
	.cfi_def_cfa_offset 44
	pushl	$4
	.cfi_def_cfa_offset 48
	call	syslog
	movl	%edi, (%esp)
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	xorl	%eax, %eax
	jmp	.L289
.L292:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pushl	$.LC83
	.cfi_def_cfa_offset 44
	pushl	$2
	.cfi_def_cfa_offset 48
	call	syslog
	movl	$1, (%esp)
	call	exit
.L311:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	$.LC84
	.cfi_def_cfa_offset 44
	pushl	$2
	.cfi_def_cfa_offset 48
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata.str1.4
	.align 4
.LC85:
	.string	"throttle sending count was negative - shouldn't happen!"
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LFB23:
	.cfi_startproc
	movl	numthrottles, %edx
	movl	$0, 52(%eax)
	movl	$-1, 60(%eax)
	movl	$-1, 56(%eax)
	testl	%edx, %edx
	jle	.L338
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
	xorl	%edi, %edi
	movl	%eax, %ebx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	jmp	.L327
	.p2align 4,,10
	.p2align 3
.L339:
	leal	1(%edx), %esi
	movl	%esi, 12(%esp)
.L317:
	movl	52(%ebx), %edx
	leal	1(%edx), %esi
	movl	%esi, 52(%ebx)
	movl	%ebp, 12(%ebx,%edx,4)
	movl	12(%esp), %edx
	movl	%edx, 20(%eax)
	movl	8(%esp), %eax
	movl	%edx, %esi
	cltd
	idivl	%esi
	movl	56(%ebx), %edx
	cmpl	$-1, %edx
	je	.L335
	cmpl	%edx, %eax
	cmovg	%edx, %eax
.L335:
	movl	%eax, 56(%ebx)
	movl	60(%ebx), %eax
	cmpl	$-1, %eax
	je	.L336
	cmpl	%ecx, %eax
	cmovge	%eax, %ecx
.L336:
	movl	%ecx, 60(%ebx)
.L315:
	addl	$1, %ebp
	cmpl	%ebp, numthrottles
	jle	.L321
	addl	$24, %edi
	cmpl	$9, 52(%ebx)
	jg	.L321
.L327:
	movl	8(%ebx), %eax
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	188(%eax)
	.cfi_def_cfa_offset 60
	movl	throttles, %eax
	pushl	(%eax,%edi)
	.cfi_def_cfa_offset 64
	call	match
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L315
	movl	throttles, %eax
	addl	%edi, %eax
	movl	4(%eax), %esi
	movl	12(%eax), %edx
	leal	(%esi,%esi), %ecx
	movl	%esi, 8(%esp)
	cmpl	%ecx, %edx
	jg	.L324
	movl	8(%eax), %ecx
	cmpl	%ecx, %edx
	jl	.L324
	movl	20(%eax), %edx
	testl	%edx, %edx
	jns	.L339
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC85
	.cfi_def_cfa_offset 60
	pushl	$3
	.cfi_def_cfa_offset 64
	call	syslog
	movl	throttles, %eax
	addl	%edi, %eax
	movl	4(%eax), %ecx
	movl	$0, 20(%eax)
	movl	%ecx, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	8(%eax), %ecx
	movl	$1, 12(%esp)
	jmp	.L317
	.p2align 4,,10
	.p2align 3
.L321:
	addl	$28, %esp
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
.L324:
	.cfi_restore_state
	addl	$28, %esp
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
.L338:
	movl	$1, %eax
	ret
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LFB18:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	xorl	%edi, %edi
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subl	$24, %esp
	.cfi_def_cfa_offset 40
	pushl	$0
	.cfi_def_cfa_offset 44
	leal	20(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 48
	call	gettimeofday
	movl	%esi, %eax
	call	logstats
	movl	max_connects, %ecx
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%ecx, %ecx
	jg	.L359
	jmp	.L347
	.p2align 4,,10
	.p2align 3
.L344:
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L345
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_destroy_conn
	addl	connects, %ebx
	popl	%eax
	.cfi_def_cfa_offset 44
	pushl	8(%ebx)
	.cfi_def_cfa_offset 48
	call	free
	subl	$1, httpd_conn_count
	movl	$0, 8(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L345:
	addl	$1, %edi
	cmpl	%edi, max_connects
	jle	.L347
.L359:
	leal	(%edi,%edi,2), %ebx
	movl	connects, %eax
	sall	$5, %ebx
	addl	%ebx, %eax
	movl	(%eax), %edx
	testl	%edx, %edx
	je	.L344
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	%esi
	.cfi_def_cfa_offset 44
	pushl	8(%eax)
	.cfi_def_cfa_offset 48
	call	httpd_close_conn
	movl	connects, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	addl	%ebx, %eax
	jmp	.L344
	.p2align 4,,10
	.p2align 3
.L347:
	movl	hs, %ebx
	testl	%ebx, %ebx
	je	.L343
	movl	40(%ebx), %eax
	movl	$0, hs
	cmpl	$-1, %eax
	je	.L348
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L348:
	movl	44(%ebx), %eax
	cmpl	$-1, %eax
	je	.L349
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L349:
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	httpd_terminate
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L343:
	call	mmc_destroy
	call	tmr_destroy
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	connects
	.cfi_def_cfa_offset 48
	call	free
	movl	throttles, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L340
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	free
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L340:
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata.str1.1
.LC86:
	.string	"exiting"
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LFB5:
	.cfi_startproc
	movl	num_connects, %edx
	testl	%edx, %edx
	je	.L372
	movl	$1, got_usr1
	ret
.L372:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC86
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	movl	$0, (%esp)
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata.str1.1
.LC87:
	.string	"exiting due to signal %d"
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LFB2:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	20(%esp)
	.cfi_def_cfa_offset 24
	pushl	$.LC87
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LFB36:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	movl	52(%eax), %ebx
	testl	%ebx, %ebx
	jle	.L375
	movl	throttles, %ecx
	leal	12(%eax), %edx
	leal	12(%eax,%ebx,4), %ebx
	.p2align 4,,10
	.p2align 3
.L377:
	movl	(%edx), %eax
	addl	$4, %edx
	leal	(%eax,%eax,2), %eax
	subl	$1, 20(%ecx,%eax,8)
	cmpl	%edx, %ebx
	jne	.L377
.L375:
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LFB28:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	8(%eax), %eax
	movl	168(%eax), %edx
	addl	%edx, stats_bytes
	cmpl	$3, (%ebx)
	je	.L382
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_del_fd
	movl	8(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L382:
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	%esi
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	httpd_close_conn
	movl	%ebx, %eax
	call	clear_throttles.isra.0
	movl	76(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	je	.L383
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	tmr_cancel
	movl	$0, 76(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L383:
	movl	first_free_connect, %eax
	movl	$0, (%ebx)
	subl	$1, num_connects
	movl	%eax, 4(%ebx)
	subl	connects, %ebx
	sarl	$5, %ebx
	imull	$-1431655765, %ebx, %ebx
	movl	%ebx, first_free_connect
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata.str1.4
	.align 4
.LC88:
	.string	"replacing non-null linger_timer!"
	.align 4
.LC89:
	.string	"tmr_create(linger_clear_connection) failed"
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LFB27:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L389
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	tmr_cancel
	movl	$0, 72(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L389:
	movl	(%ebx), %edx
	cmpl	$4, %edx
	je	.L402
	movl	8(%ebx), %eax
	movl	356(%eax), %ecx
	testl	%ecx, %ecx
	je	.L391
	cmpl	$3, %edx
	je	.L392
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_del_fd
	movl	8(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L392:
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	movl	$4, (%ebx)
	pushl	$1
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	shutdown
	movl	8(%ebx), %eax
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	pushl	$0
	.cfi_def_cfa_offset 24
	pushl	%ebx
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_add_fd
	movl	76(%ebx), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%edx, %edx
	je	.L393
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC88
	.cfi_def_cfa_offset 28
	pushl	$3
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L393:
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$0
	.cfi_def_cfa_offset 32
	pushl	$500
	.cfi_def_cfa_offset 36
	pushl	%ebx
	.cfi_def_cfa_offset 40
	pushl	$linger_clear_connection
	.cfi_def_cfa_offset 44
	pushl	%esi
	.cfi_def_cfa_offset 48
	call	tmr_create
	addl	$32, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	movl	%eax, 76(%ebx)
	je	.L403
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
	.p2align 4,,10
	.p2align 3
.L402:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	76(%ebx)
	.cfi_def_cfa_offset 32
	call	tmr_cancel
	movl	8(%ebx), %eax
	movl	$0, 76(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	movl	$0, 356(%eax)
.L391:
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	movl	%esi, %edx
	movl	%ebx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	jmp	really_clear_connection
.L403:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC89
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LFB26:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%edx, %esi
	movl	%eax, %ebx
	subl	$16, %esp
	.cfi_def_cfa_offset 28
	pushl	8(%eax)
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
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LFB20:
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
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %esi
	subl	$12, %esp
	.cfi_def_cfa_offset 32
	movl	8(%eax), %ebx
	movl	144(%ebx), %edx
	movl	140(%ebx), %eax
	cmpl	%eax, %edx
	jb	.L407
	cmpl	$5000, %eax
	jbe	.L435
.L434:
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	$.LC45
	.cfi_def_cfa_offset 44
	pushl	httpd_err400form
	.cfi_def_cfa_offset 48
	pushl	$.LC45
	.cfi_def_cfa_offset 52
	pushl	httpd_err400title
	.cfi_def_cfa_offset 56
	pushl	$400
	.cfi_def_cfa_offset 60
.L433:
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	httpd_send_err
	movl	%edi, %edx
	movl	%esi, %eax
	addl	$44, %esp
	.cfi_def_cfa_offset 20
.L430:
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
.L435:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	addl	$1000, %eax
	pushl	%eax
	.cfi_def_cfa_offset 40
	leal	140(%ebx), %eax
	pushl	%eax
	.cfi_def_cfa_offset 44
	leal	136(%ebx), %eax
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_realloc_str
	movl	140(%ebx), %eax
	movl	144(%ebx), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L407:
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	subl	%edx, %eax
	pushl	%eax
	.cfi_def_cfa_offset 40
	addl	136(%ebx), %edx
	pushl	%edx
	.cfi_def_cfa_offset 44
	pushl	448(%ebx)
	.cfi_def_cfa_offset 48
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L434
	js	.L436
	addl	%eax, 144(%ebx)
	movl	(%edi), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	movl	%eax, 68(%esi)
	call	httpd_got_request
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L406
	cmpl	$2, %eax
	je	.L434
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	httpd_parse_request
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	js	.L431
	movl	%esi, %eax
	call	check_throttles
	testl	%eax, %eax
	je	.L437
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	%edi
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	httpd_start_request
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	js	.L431
	movl	336(%ebx), %edx
	testl	%edx, %edx
	je	.L417
	movl	344(%ebx), %eax
	movl	%eax, 92(%esi)
	movl	348(%ebx), %eax
	addl	$1, %eax
	movl	%eax, 88(%esi)
.L418:
	movl	452(%ebx), %eax
	testl	%eax, %eax
	je	.L438
	movl	88(%esi), %eax
	cmpl	%eax, 92(%esi)
	jl	.L439
.L431:
	movl	%edi, %edx
	movl	%esi, %eax
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	jmp	.L430
.L439:
	.cfi_restore_state
	movl	(%edi), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	448(%ebx)
	.cfi_def_cfa_offset 48
	movl	$2, (%esi)
	movl	$0, 80(%esi)
	movl	%eax, 64(%esi)
	call	fdwatch_del_fd
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	$1
	.cfi_def_cfa_offset 40
	pushl	%esi
	.cfi_def_cfa_offset 44
	pushl	448(%ebx)
	.cfi_def_cfa_offset 48
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L406:
	addl	$12, %esp
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
.L436:
	.cfi_restore_state
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L406
	cmpl	$11, %eax
	jne	.L434
	jmp	.L406
	.p2align 4,,10
	.p2align 3
.L437:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pushl	172(%ebx)
	.cfi_def_cfa_offset 44
	pushl	httpd_err503form
	.cfi_def_cfa_offset 48
	pushl	$.LC45
	.cfi_def_cfa_offset 52
	pushl	httpd_err503title
	.cfi_def_cfa_offset 56
	pushl	$503
	.cfi_def_cfa_offset 60
	jmp	.L433
	.p2align 4,,10
	.p2align 3
.L417:
	.cfi_restore_state
	movl	164(%ebx), %eax
	movl	$0, %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	movl	%eax, 88(%esi)
	jmp	.L418
.L438:
	movl	52(%esi), %edx
	testl	%edx, %edx
	jle	.L440
	movl	throttles, %ecx
	movl	168(%ebx), %ebx
	leal	12(%esi), %eax
	leal	12(%esi,%edx,4), %ebp
	.p2align 4,,10
	.p2align 3
.L423:
	movl	(%eax), %edx
	addl	$4, %eax
	leal	(%edx,%edx,2), %edx
	addl	%ebx, 16(%ecx,%edx,8)
	cmpl	%eax, %ebp
	jne	.L423
.L422:
	movl	%ebx, 92(%esi)
	jmp	.L431
.L440:
	movl	168(%ebx), %ebx
	jmp	.L422
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata.str1.4
	.align 4
.LC90:
	.string	"%.80s connection timed out reading"
	.align 4
.LC91:
	.string	"%.80s connection timed out sending"
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
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
	subl	$12, %esp
	.cfi_def_cfa_offset 32
	movl	max_connects, %ecx
	movl	36(%esp), %ebp
	testl	%ecx, %ecx
	jle	.L441
	xorl	%edi, %edi
	xorl	%esi, %esi
	jmp	.L448
	.p2align 4,,10
	.p2align 3
.L453:
	jl	.L443
	cmpl	$3, %eax
	jg	.L443
	movl	0(%ebp), %eax
	subl	68(%ebx), %eax
	cmpl	$299, %eax
	jg	.L452
.L443:
	addl	$1, %esi
	addl	$96, %edi
	cmpl	%esi, max_connects
	jle	.L441
.L448:
	movl	connects, %ebx
	addl	%edi, %ebx
	movl	(%ebx), %eax
	cmpl	$1, %eax
	jne	.L453
	movl	0(%ebp), %eax
	subl	68(%ebx), %eax
	cmpl	$59, %eax
	jle	.L443
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	addl	$1, %esi
	addl	$96, %edi
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	$.LC90
	.cfi_def_cfa_offset 44
	pushl	$6
	.cfi_def_cfa_offset 48
	call	syslog
	popl	%eax
	.cfi_def_cfa_offset 44
	popl	%edx
	.cfi_def_cfa_offset 40
	pushl	$.LC45
	.cfi_def_cfa_offset 44
	pushl	httpd_err408form
	.cfi_def_cfa_offset 48
	pushl	$.LC45
	.cfi_def_cfa_offset 52
	pushl	httpd_err408title
	.cfi_def_cfa_offset 56
	pushl	$408
	.cfi_def_cfa_offset 60
	pushl	8(%ebx)
	.cfi_def_cfa_offset 64
	call	httpd_send_err
	addl	$32, %esp
	.cfi_def_cfa_offset 32
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	finish_connection
	cmpl	%esi, max_connects
	jg	.L448
.L441:
	addl	$12, %esp
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
.L452:
	.cfi_restore_state
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	$.LC91
	.cfi_def_cfa_offset 44
	pushl	$6
	.cfi_def_cfa_offset 48
	call	syslog
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	clear_connection
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	jmp	.L443
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.4
	.align 4
.LC92:
	.string	"replacing non-null wakeup_timer!"
	.align 4
.LC93:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC94:
	.string	"write - %m sending %.80s"
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB21:
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
	subl	$44, %esp
	.cfi_def_cfa_offset 64
	movl	8(%eax), %edi
	movl	%edx, 4(%esp)
	movl	56(%eax), %edx
	movl	$1000000000, %eax
	cmpl	$-1, %edx
	je	.L455
	leal	3(%edx), %eax
	testl	%edx, %edx
	cmovns	%edx, %eax
	sarl	$2, %eax
.L455:
	movl	304(%edi), %edx
	testl	%edx, %edx
	jne	.L456
	movl	92(%ebx), %ecx
	movl	88(%ebx), %edx
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	subl	%ecx, %edx
	cmpl	%eax, %edx
	cmovbe	%edx, %eax
	addl	452(%edi), %ecx
	pushl	%eax
	.cfi_def_cfa_offset 72
	pushl	%ecx
	.cfi_def_cfa_offset 76
	pushl	448(%edi)
	.cfi_def_cfa_offset 80
	call	write
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	js	.L512
.L458:
	je	.L461
	movl	4(%esp), %esi
	movl	(%esi), %edx
	movl	%edx, 68(%ebx)
	movl	304(%edi), %edx
	testl	%edx, %edx
	je	.L467
	cmpl	%eax, %edx
	ja	.L513
	subl	%edx, %eax
	movl	$0, 304(%edi)
.L467:
	movl	92(%ebx), %esi
	movl	8(%ebx), %edx
	movl	52(%ebx), %ecx
	addl	%eax, %esi
	movl	%esi, 92(%ebx)
	movl	%esi, 8(%esp)
	movl	168(%edx), %esi
	addl	%eax, %esi
	testl	%ecx, %ecx
	movl	%esi, 12(%esp)
	movl	%esi, 168(%edx)
	jle	.L473
	movl	throttles, %esi
	leal	12(%ebx), %edx
	leal	12(%ebx,%ecx,4), %ebp
	.p2align 4,,10
	.p2align 3
.L472:
	movl	(%edx), %ecx
	addl	$4, %edx
	leal	(%ecx,%ecx,2), %ecx
	addl	%eax, 16(%esi,%ecx,8)
	cmpl	%ebp, %edx
	jne	.L472
.L473:
	movl	8(%esp), %eax
	cmpl	88(%ebx), %eax
	jge	.L514
	movl	80(%ebx), %eax
	cmpl	$100, %eax
	jg	.L515
.L474:
	movl	56(%ebx), %ecx
	cmpl	$-1, %ecx
	je	.L454
	movl	4(%esp), %eax
	movl	(%eax), %esi
	subl	64(%ebx), %esi
	movl	$1, %eax
	cmove	%eax, %esi
	movl	12(%esp), %eax
	cltd
	idivl	%esi
	cmpl	%eax, %ecx
	jge	.L454
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	448(%edi)
	.cfi_def_cfa_offset 80
	movl	$3, (%ebx)
	call	fdwatch_del_fd
	movl	8(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	movl	168(%eax), %eax
	cltd
	idivl	56(%ebx)
	subl	%esi, %eax
	movl	%eax, %esi
	movl	72(%ebx), %eax
	testl	%eax, %eax
	je	.L476
	subl	$8, %esp
	.cfi_def_cfa_offset 72
	pushl	$.LC92
	.cfi_def_cfa_offset 76
	pushl	$3
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 64
.L476:
	imull	$1000, %esi, %eax
	movl	$500, %edx
	testl	%esi, %esi
	cmovle	%edx, %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$0
	.cfi_def_cfa_offset 80
	pushl	%eax
	.cfi_def_cfa_offset 84
	jmp	.L510
	.p2align 4,,10
	.p2align 3
.L456:
	.cfi_restore_state
	movl	252(%edi), %ecx
	movl	%edx, 20(%esp)
	movl	88(%ebx), %esi
	movl	92(%ebx), %edx
	movl	%ecx, 16(%esp)
	movl	452(%edi), %ecx
	subl	%edx, %esi
	addl	%edx, %ecx
	cmpl	%eax, %esi
	cmovbe	%esi, %eax
	movl	%ecx, 24(%esp)
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	movl	%eax, 32(%esp)
	pushl	$2
	.cfi_def_cfa_offset 72
	leal	24(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	448(%edi)
	.cfi_def_cfa_offset 80
	call	writev
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	jns	.L458
.L512:
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L454
	cmpl	$11, %eax
	je	.L461
	cmpl	$32, %eax
	setne	%cl
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L465
	cmpl	$104, %eax
	je	.L465
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	172(%edi)
	.cfi_def_cfa_offset 72
	pushl	$.LC94
	.cfi_def_cfa_offset 76
	pushl	$3
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 64
.L465:
	movl	4(%esp), %edx
	movl	%ebx, %eax
	call	clear_connection
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
.L461:
	.cfi_restore_state
	addl	$100, 80(%ebx)
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	448(%edi)
	.cfi_def_cfa_offset 80
	movl	$3, (%ebx)
	call	fdwatch_del_fd
	movl	72(%ebx), %ecx
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%ecx, %ecx
	je	.L464
	subl	$8, %esp
	.cfi_def_cfa_offset 72
	pushl	$.LC92
	.cfi_def_cfa_offset 76
	pushl	$3
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 64
.L464:
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	$0
	.cfi_def_cfa_offset 80
	pushl	80(%ebx)
	.cfi_def_cfa_offset 84
.L510:
	pushl	%ebx
	.cfi_def_cfa_offset 88
	pushl	$wakeup_connection
	.cfi_def_cfa_offset 92
	pushl	32(%esp)
	.cfi_def_cfa_offset 96
	call	tmr_create
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	movl	%eax, 72(%ebx)
	je	.L516
.L454:
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
.L515:
	.cfi_restore_state
	subl	$100, %eax
	movl	%eax, 80(%ebx)
	jmp	.L474
	.p2align 4,,10
	.p2align 3
.L513:
	movl	%edx, %esi
	movl	252(%edi), %edx
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	subl	%eax, %esi
	pushl	%esi
	.cfi_def_cfa_offset 72
	addl	%edx, %eax
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	memmove
	movl	%esi, 304(%edi)
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	xorl	%eax, %eax
	jmp	.L467
	.p2align 4,,10
	.p2align 3
.L514:
	movl	4(%esp), %edx
	movl	%ebx, %eax
	call	finish_connection
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
.L516:
	.cfi_restore_state
	pushl	%edx
	.cfi_def_cfa_offset 68
	pushl	%edx
	.cfi_def_cfa_offset 72
	pushl	$.LC93
	.cfi_def_cfa_offset 76
	pushl	$2
	.cfi_def_cfa_offset 80
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	movl	$0, 76(%eax)
	jmp	really_clear_connection
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	subl	$4104, %esp
	.cfi_def_cfa_offset 4116
	pushl	$4096
	.cfi_def_cfa_offset 4120
	leal	8(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 4124
	movl	8(%ebx), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 4128
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 4112
	testl	%eax, %eax
	js	.L523
	je	.L521
.L518:
	addl	$4100, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L523:
	.cfi_restore_state
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L518
	cmpl	$11, %eax
	je	.L518
.L521:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	really_clear_connection
	addl	$4100, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.1
.LC95:
	.string	"%d"
.LC96:
	.string	"getaddrinfo %.80s - %.80s"
.LC97:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.4
	.align 4
.LC98:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB37:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%ecx, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %esi
	xorl	%eax, %eax
	subl	$76, %esp
	.cfi_def_cfa_offset 96
	movl	%edx, 12(%esp)
.L525:
	movl	$0, 32(%esp,%eax)
	addl	$4, %eax
	cmpl	$32, %eax
	jb	.L525
	movzwl	port, %eax
	movl	$1, 32(%esp)
	movl	$1, 40(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 100
	pushl	$.LC95
	.cfi_def_cfa_offset 104
	pushl	$10
	.cfi_def_cfa_offset 108
	leal	34(%esp), %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 112
	call	snprintf
	leal	32(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 116
	leal	52(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 120
	pushl	%ebx
	.cfi_def_cfa_offset 124
	pushl	hostname
	.cfi_def_cfa_offset 128
	call	getaddrinfo
	addl	$32, %esp
	.cfi_def_cfa_offset 96
	testl	%eax, %eax
	movl	%eax, %ebx
	jne	.L546
	movl	16(%esp), %eax
	testl	%eax, %eax
	je	.L528
	xorl	%ebx, %ebx
	xorl	%edx, %edx
	jmp	.L532
	.p2align 4,,10
	.p2align 3
.L548:
	cmpl	$10, %ecx
	jne	.L529
	testl	%edx, %edx
	cmove	%eax, %edx
.L529:
	movl	28(%eax), %eax
	testl	%eax, %eax
	je	.L547
.L532:
	movl	4(%eax), %ecx
	cmpl	$2, %ecx
	jne	.L548
	testl	%ebx, %ebx
	cmove	%eax, %ebx
	movl	28(%eax), %eax
	testl	%eax, %eax
	jne	.L532
.L547:
	testl	%edx, %edx
	je	.L549
	movl	16(%edx), %ecx
	cmpl	$128, %ecx
	ja	.L550
	movl	$32, %ecx
	movl	%ebp, %edi
	subl	$4, %esp
	.cfi_def_cfa_offset 100
	rep stosl
	pushl	16(%edx)
	.cfi_def_cfa_offset 104
	pushl	20(%edx)
	.cfi_def_cfa_offset 108
	pushl	%ebp
	.cfi_def_cfa_offset 112
	call	memmove
	movl	112(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 96
	movl	$1, (%eax)
.L534:
	testl	%ebx, %ebx
	je	.L551
	movl	16(%ebx), %eax
	cmpl	$128, %eax
	ja	.L552
	xorl	%eax, %eax
	movl	$32, %ecx
	movl	%esi, %edi
	rep stosl
	subl	$4, %esp
	.cfi_def_cfa_offset 100
	pushl	16(%ebx)
	.cfi_def_cfa_offset 104
	pushl	20(%ebx)
	.cfi_def_cfa_offset 108
	pushl	%esi
	.cfi_def_cfa_offset 112
	call	memmove
	movl	28(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 96
	movl	$1, (%eax)
.L537:
	subl	$12, %esp
	.cfi_def_cfa_offset 108
	pushl	28(%esp)
	.cfi_def_cfa_offset 112
	call	freeaddrinfo
	addl	$92, %esp
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
.L549:
	.cfi_def_cfa_offset 96
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	movl	%ebx, %eax
.L528:
	movl	96(%esp), %edi
	movl	%eax, %ebx
	movl	$0, (%edi)
	jmp	.L534
.L551:
	movl	12(%esp), %eax
	movl	$0, (%eax)
	jmp	.L537
.L546:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 108
	pushl	%eax
	.cfi_def_cfa_offset 112
	call	gai_strerror
	pushl	%eax
	.cfi_def_cfa_offset 116
	pushl	hostname
	.cfi_def_cfa_offset 120
	pushl	$.LC96
	.cfi_def_cfa_offset 124
	pushl	$2
	.cfi_def_cfa_offset 128
	call	syslog
	addl	$20, %esp
	.cfi_def_cfa_offset 108
	pushl	%ebx
	.cfi_def_cfa_offset 112
	call	gai_strerror
	movl	%eax, (%esp)
	pushl	hostname
	.cfi_def_cfa_offset 116
	pushl	argv0
	.cfi_def_cfa_offset 120
	pushl	$.LC97
	.cfi_def_cfa_offset 124
	pushl	stderr
	.cfi_def_cfa_offset 128
	call	fprintf
	addl	$20, %esp
	.cfi_def_cfa_offset 108
	pushl	$1
	.cfi_def_cfa_offset 112
	call	exit
.L552:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 108
	pushl	%eax
	.cfi_def_cfa_offset 112
.L545:
	pushl	$128
	.cfi_def_cfa_offset 116
	pushl	hostname
	.cfi_def_cfa_offset 120
	pushl	$.LC98
	.cfi_def_cfa_offset 124
	pushl	$2
	.cfi_def_cfa_offset 128
	call	syslog
	addl	$20, %esp
	.cfi_def_cfa_offset 108
	pushl	$1
	.cfi_def_cfa_offset 112
	call	exit
.L550:
	.cfi_def_cfa_offset 96
	subl	$12, %esp
	.cfi_def_cfa_offset 108
	pushl	%ecx
	.cfi_def_cfa_offset 112
	jmp	.L545
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.1
.LC99:
	.string	"can't find any valid address"
	.section	.rodata.str1.4
	.align 4
.LC100:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC101:
	.string	"unknown user - '%.80s'"
.LC102:
	.string	"%s: unknown user - '%s'\n"
.LC103:
	.string	"/dev/null"
	.section	.rodata.str1.4
	.align 4
.LC104:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 4
.LC105:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC106:
	.string	"fchown logfile - %m"
.LC107:
	.string	"fchown logfile"
.LC108:
	.string	"chdir - %m"
.LC109:
	.string	"chdir"
.LC110:
	.string	"daemon - %m"
.LC111:
	.string	"w"
.LC112:
	.string	"%d\n"
	.section	.rodata.str1.4
	.align 4
.LC113:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC114:
	.string	"chroot - %m"
	.section	.rodata.str1.4
	.align 4
.LC115:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 4
.LC116:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC117:
	.string	"chroot chdir - %m"
.LC118:
	.string	"chroot chdir"
.LC119:
	.string	"data_dir chdir - %m"
.LC120:
	.string	"data_dir chdir"
.LC121:
	.string	"tmr_create(occasional) failed"
.LC122:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.4
	.align 4
.LC123:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC124:
	.string	"tmr_create(show_stats) failed"
.LC125:
	.string	"setgroups - %m"
.LC126:
	.string	"setgid - %m"
.LC127:
	.string	"initgroups - %m"
.LC128:
	.string	"setuid - %m"
	.section	.rodata.str1.4
	.align 4
.LC129:
	.string	"started as root without requesting chroot(), warning only"
	.align 4
.LC130:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC131:
	.string	"fdwatch - %m"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
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
	subl	$4416, %esp
	movl	4(%ecx), %esi
	movl	(%ecx), %edi
	movl	(%esi), %ebx
	pushl	$47
	pushl	%ebx
	movl	%ebx, argv0
	call	strrchr
	leal	1(%eax), %edx
	addl	$12, %esp
	testl	%eax, %eax
	pushl	$24
	pushl	$9
	cmovne	%edx, %ebx
	pushl	%ebx
	call	openlog
	movl	%edi, %eax
	movl	%esi, %edx
	call	parse_args
	call	tzset
	leal	-4392(%ebp), %eax
	leal	-4252(%ebp), %ecx
	leal	-4396(%ebp), %edx
	movl	%eax, (%esp)
	leal	-4380(%ebp), %eax
	call	lookup_hostname.constprop.1
	movl	-4396(%ebp), %edi
	addl	$16, %esp
	testl	%edi, %edi
	jne	.L555
	cmpl	$0, -4392(%ebp)
	je	.L685
.L555:
	movl	throttlefile, %eax
	movl	$0, numthrottles
	movl	$0, maxthrottles
	movl	$0, throttles
	testl	%eax, %eax
	je	.L556
	call	read_throttlefile
.L556:
	call	getuid
	testl	%eax, %eax
	movl	$32767, -4412(%ebp)
	movl	$32767, -4416(%ebp)
	je	.L686
.L557:
	movl	logfile, %ebx
	testl	%ebx, %ebx
	je	.L625
	movl	$.LC103, %edi
	movl	$10, %ecx
	movl	%ebx, %esi
	repz cmpsb
	je	.L687
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC78
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L561
	movl	stdout, %esi
.L559:
	movl	dir, %eax
	testl	%eax, %eax
	je	.L565
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L688
.L565:
	leal	-4121(%ebp), %ebx
	subl	$8, %esp
	pushl	$4096
	pushl	%ebx
	call	getcwd
	movl	%ebx, (%esp)
	call	strlen
	addl	$16, %esp
	cmpb	$47, -4122(%ebp,%eax)
	je	.L566
	movw	$47, (%ebx,%eax)
.L566:
	movl	debug, %ecx
	testl	%ecx, %ecx
	jne	.L567
	subl	$12, %esp
	pushl	stdin
	call	fclose
	movl	stdout, %eax
	addl	$16, %esp
	cmpl	%eax, %esi
	je	.L568
	subl	$12, %esp
	pushl	%eax
	call	fclose
	addl	$16, %esp
.L568:
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
	js	.L689
.L569:
	movl	pidfile, %eax
	testl	%eax, %eax
	je	.L570
	pushl	%edi
	pushl	%edi
	pushl	$.LC111
	pushl	%eax
	call	fopen
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %edi
	je	.L690
	call	getpid
	pushl	%edx
	pushl	%eax
	pushl	$.LC112
	pushl	%edi
	call	fprintf
	movl	%edi, (%esp)
	call	fclose
	addl	$16, %esp
.L570:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects
	js	.L691
	subl	$10, %eax
	cmpl	$0, do_chroot
	movl	%eax, max_connects
	jne	.L692
.L573:
	movl	data_dir, %eax
	testl	%eax, %eax
	je	.L577
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L693
.L577:
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
	popl	%edi
	pushl	$handle_chld
	pushl	$17
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$13
	call	sigset
	popl	%ecx
	popl	%edi
	pushl	$handle_hup
	pushl	$1
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_usr1
	pushl	$10
	call	sigset
	popl	%ecx
	popl	%edi
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
	popl	%edi
	popl	%eax
	xorl	%eax, %eax
	cmpl	$0, -4392(%ebp)
	leal	-4252(%ebp), %edx
	movzwl	port, %ecx
	leal	-4380(%ebp), %edi
	pushl	no_empty_referers
	pushl	local_pattern
	pushl	url_pattern
	pushl	do_global_passwd
	pushl	do_vhost
	cmove	%eax, %edx
	cmpl	$0, -4396(%ebp)
	pushl	no_symlink_check
	pushl	%esi
	pushl	no_log
	pushl	%ebx
	pushl	max_age
	pushl	p3p
	pushl	charset
	cmovne	%edi, %eax
	pushl	cgi_limit
	pushl	cgi_pattern
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	pushl	hostname
	call	httpd_initialize
	addl	$80, %esp
	testl	%eax, %eax
	movl	%eax, hs
	je	.L694
	subl	$12, %esp
	pushl	$1
	pushl	$120000
	pushl	JunkClientData
	pushl	$occasional
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L695
	subl	$12, %esp
	pushl	$1
	pushl	$5000
	pushl	JunkClientData
	pushl	$idle
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L696
	cmpl	$0, numthrottles
	jle	.L583
	subl	$12, %esp
	pushl	$1
	pushl	$2000
	pushl	JunkClientData
	pushl	$update_throttles
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L697
.L583:
	subl	$12, %esp
	pushl	$1
	pushl	$3600000
	pushl	JunkClientData
	pushl	$show_stats
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L698
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
	jne	.L586
	pushl	%edx
	pushl	%edx
	pushl	$0
	pushl	$0
	call	setgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L699
	subl	$12, %esp
	pushl	-4412(%ebp)
	call	setgid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L700
	pushl	%eax
	pushl	%eax
	pushl	-4412(%ebp)
	pushl	user
	call	initgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L701
.L589:
	subl	$12, %esp
	pushl	-4416(%ebp)
	call	setuid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L702
	cmpl	$0, do_chroot
	je	.L703
.L586:
	movl	max_connects, %ebx
	subl	$12, %esp
	imull	$96, %ebx, %esi
	pushl	%esi
	call	malloc
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, connects
	je	.L592
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	movl	%eax, %edx
	jle	.L597
	.p2align 4,,10
	.p2align 3
.L664:
	addl	$1, %ecx
	movl	$0, (%edx)
	movl	$0, 8(%edx)
	movl	%ecx, 4(%edx)
	addl	$96, %edx
	cmpl	%ecx, %ebx
	jne	.L664
.L597:
	movl	$-1, -92(%eax,%esi)
	movl	hs, %eax
	movl	$0, first_free_connect
	movl	$0, num_connects
	movl	$0, httpd_conn_count
	testl	%eax, %eax
	je	.L598
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L599
	pushl	%esi
	pushl	$0
	pushl	$0
	pushl	%edx
	call	fdwatch_add_fd
	movl	hs, %eax
	addl	$16, %esp
.L599:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L598
	pushl	%ebx
	pushl	$0
	pushl	$0
	pushl	%eax
	call	fdwatch_add_fd
	addl	$16, %esp
.L598:
	leal	-4388(%ebp), %esi
	subl	$12, %esp
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	.p2align 4,,10
	.p2align 3
.L600:
	movl	terminate, %edx
	testl	%edx, %edx
	je	.L623
	cmpl	$0, num_connects
	jle	.L704
.L623:
	movl	got_hup, %eax
	testl	%eax, %eax
	jne	.L705
.L601:
	subl	$12, %esp
	pushl	%esi
	call	tmr_mstimeout
	movl	%eax, (%esp)
	call	fdwatch
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L706
	subl	$12, %esp
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	testl	%ebx, %ebx
	je	.L707
	movl	hs, %eax
	testl	%eax, %eax
	je	.L614
	movl	44(%eax), %edx
	cmpl	$-1, %edx
	je	.L609
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L610
.L613:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L614
.L609:
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L614
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L708
	.p2align 4,,10
	.p2align 3
.L614:
	call	fdwatch_get_next_client_data
	cmpl	$-1, %eax
	movl	%eax, %ebx
	je	.L709
	testl	%ebx, %ebx
	je	.L614
	movl	8(%ebx), %eax
	subl	$12, %esp
	pushl	448(%eax)
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	je	.L710
	movl	(%ebx), %eax
	cmpl	$2, %eax
	je	.L617
	cmpl	$4, %eax
	je	.L618
	cmpl	$1, %eax
	jne	.L614
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_read
	jmp	.L614
.L687:
	movl	$1, no_log
	xorl	%esi, %esi
	jmp	.L559
.L567:
	call	setsid
	jmp	.L569
.L686:
	subl	$12, %esp
	pushl	user
	call	getpwnam
	addl	$16, %esp
	testl	%eax, %eax
	je	.L711
	movl	8(%eax), %edi
	movl	12(%eax), %eax
	movl	%edi, -4416(%ebp)
	movl	%eax, -4412(%ebp)
	jmp	.L557
.L685:
	pushl	%esi
	pushl	%esi
	pushl	$.LC99
	pushl	$3
	call	syslog
	addl	$12, %esp
	pushl	argv0
	pushl	$.LC100
	pushl	stderr
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L710:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	clear_connection
	jmp	.L614
.L706:
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L600
	cmpl	$11, %eax
	je	.L600
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC131
	pushl	$3
	call	syslog
	movl	$1, (%esp)
	call	exit
.L618:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_linger
	jmp	.L614
.L617:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_send
	jmp	.L614
.L709:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	movl	got_usr1, %eax
	addl	$16, %esp
	testl	%eax, %eax
	je	.L600
	cmpl	$0, terminate
	jne	.L600
	movl	hs, %eax
	movl	$1, terminate
	testl	%eax, %eax
	je	.L600
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L621
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_del_fd
	movl	hs, %eax
	addl	$16, %esp
.L621:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L622
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_del_fd
	addl	$16, %esp
.L622:
	subl	$12, %esp
	pushl	hs
	call	httpd_unlisten
	addl	$16, %esp
	jmp	.L600
.L705:
	call	re_open_logfile
	movl	$0, got_hup
	jmp	.L601
.L707:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	addl	$16, %esp
	jmp	.L600
.L692:
	subl	$12, %esp
	pushl	%ebx
	call	chroot
	addl	$16, %esp
	testl	%eax, %eax
	js	.L712
	movl	logfile, %edx
	testl	%edx, %edx
	je	.L575
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC78
	pushl	%edx
	movl	%edx, -4420(%ebp)
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	je	.L575
	xorl	%eax, %eax
	orl	$-1, %ecx
	movl	%ebx, %edi
	repnz scasb
	pushl	%edx
	movl	-4420(%ebp), %edx
	movl	%ecx, %edi
	notl	%edi
	leal	-1(%edi), %eax
	pushl	%eax
	pushl	%ebx
	pushl	%edx
	call	strncmp
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L576
	movl	-4420(%ebp), %edx
	pushl	%eax
	pushl	%eax
	leal	-2(%edx,%edi), %eax
	pushl	%eax
	pushl	%edx
	call	strcpy
	addl	$16, %esp
.L575:
	subl	$12, %esp
	movw	$47, -4121(%ebp)
	pushl	%ebx
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L573
	pushl	%eax
	pushl	%eax
	pushl	$.LC117
	pushl	$2
	call	syslog
	movl	$.LC118, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L625:
	xorl	%esi, %esi
	jmp	.L559
.L561:
	pushl	%eax
	pushl	%eax
	pushl	$.LC80
	pushl	%ebx
	call	fopen
	movl	logfile, %ebx
	movl	%eax, %esi
	popl	%eax
	popl	%edx
	pushl	$384
	pushl	%ebx
	call	chmod
	addl	$16, %esp
	testl	%esi, %esi
	je	.L628
	testl	%eax, %eax
	jne	.L628
	cmpb	$47, (%ebx)
	je	.L564
	pushl	%eax
	pushl	%eax
	pushl	$.LC104
	pushl	$4
	call	syslog
	addl	$12, %esp
	pushl	argv0
	pushl	$.LC105
	pushl	stderr
	call	fprintf
	addl	$16, %esp
.L564:
	subl	$12, %esp
	pushl	%esi
	call	fileno
	addl	$12, %esp
	pushl	$1
	pushl	$2
	pushl	%eax
	call	fcntl
	call	getuid
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L559
	subl	$12, %esp
	pushl	%esi
	call	fileno
	addl	$12, %esp
	pushl	-4412(%ebp)
	pushl	-4416(%ebp)
	pushl	%eax
	call	fchown
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L559
	pushl	%edi
	pushl	%edi
	pushl	$.LC106
	pushl	$4
	call	syslog
	movl	$.LC107, (%esp)
	call	perror
	addl	$16, %esp
	jmp	.L559
.L688:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC108
	pushl	$2
	call	syslog
	movl	$.LC109, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L690:
	pushl	%ecx
	pushl	pidfile
	pushl	$.LC70
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L691:
	pushl	%esi
	pushl	%esi
	pushl	$.LC113
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L694:
	subl	$12, %esp
	pushl	$1
	call	exit
.L695:
	pushl	%edi
	pushl	%edi
	pushl	$.LC121
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L693:
	pushl	%eax
	pushl	%eax
	pushl	$.LC119
	pushl	$2
	call	syslog
	movl	$.LC120, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L576:
	pushl	%eax
	pushl	%eax
	pushl	$.LC115
	pushl	$4
	call	syslog
	addl	$12, %esp
	pushl	argv0
	pushl	$.LC116
	pushl	stderr
	call	fprintf
	addl	$16, %esp
	jmp	.L575
.L703:
	pushl	%eax
	pushl	%eax
	pushl	$.LC129
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L586
.L697:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC123
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L689:
	pushl	%eax
	pushl	%eax
	pushl	$.LC110
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L610:
	movl	hs, %eax
	movl	44(%eax), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L600
	jmp	.L613
.L708:
	movl	hs, %eax
	movl	40(%eax), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L600
	jmp	.L614
.L698:
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC124
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L699:
	pushl	%eax
	pushl	%eax
	pushl	$.LC125
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L628:
	pushl	%eax
	pushl	%ebx
	pushl	$.LC70
	pushl	$2
	call	syslog
	popl	%eax
	pushl	logfile
	call	perror
	movl	$1, (%esp)
	call	exit
.L700:
	pushl	%eax
	pushl	%eax
	pushl	$.LC126
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L704:
	call	shut_down
	pushl	%eax
	pushl	%eax
	pushl	$.LC86
	pushl	$5
	call	syslog
	call	closelog
	movl	$0, (%esp)
	call	exit
.L696:
	pushl	%esi
	pushl	%esi
	pushl	$.LC122
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L712:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC114
	pushl	$2
	call	syslog
	movl	$.LC18, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L711:
	pushl	%ebx
	pushl	user
	pushl	$.LC101
	pushl	$2
	call	syslog
	pushl	user
	pushl	argv0
	pushl	$.LC102
	pushl	stderr
	call	fprintf
	addl	$20, %esp
	pushl	$1
	call	exit
.L592:
	pushl	%edi
	pushl	%edi
	pushl	$.LC130
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L701:
	pushl	%eax
	pushl	%eax
	pushl	$.LC127
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L589
.L702:
	pushl	%eax
	pushl	%eax
	pushl	$.LC128
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,4,4
	.comm	stats_connections,4,4
	.comm	stats_time,4,4
	.comm	start_time,4,4
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,4,4
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,4,4
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,4,4
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,4,4
	.local	charset
	.comm	charset,4,4
	.local	user
	.comm	user,4,4
	.local	pidfile
	.comm	pidfile,4,4
	.local	hostname
	.comm	hostname,4,4
	.local	throttlefile
	.comm	throttlefile,4,4
	.local	logfile
	.comm	logfile,4,4
	.local	local_pattern
	.comm	local_pattern,4,4
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,4,4
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,4,4
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,4,4
	.local	dir
	.comm	dir,4,4
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,4,4
	.ident	"GCC: (GNU) 6.2.0"
	.section	.note.GNU-stack,"",@progbits
