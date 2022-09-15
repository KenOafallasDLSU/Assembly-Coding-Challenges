.globl main    # OAFALLAS, Kenneth Neil B. / HyperbolicSineFunction

.data
x: .float 7.12
msg1: .asciz "Term 1: "
msgFinal: .asciz "Final Answer: "

.text
main:
	la s0, x				
	flw fs0, (s0)			# fs0 = x
	fmul.s fs1, fs0, fs0	# fs1 = x^2
	fsgnj.s fs2, fs0, fs0	# fs2 = term storage, t1 always equal to x
	fsgnj.s fs3, fs0, fs0 	# fs3 = sum, starts with x
	
	li t0, 0x1				# int counter
	fcvt.s.wu fs4, t0		# fs4 = 1 as float
	fsgnj.s ft0, fs4, fs4	# ft0 = term counter
	li s1, 0x6				# guard
	
	la s2, msg1
	addi s2, s2, 0x5		# num part of msg1
	lb t1, (s2)
	
L1:	
	li a7, 60				# load syscall messageDialogFloat
	la a0, msg1
	fsgnj.s fa1, fs2, fs2
	ecall
	
	beq t0, s1, displayFinal
	
	fmul.s fs2, fs2, fs1	# get next term prev*(x^2)/(n+1)/(n+2)
	fadd.s ft0, ft0, fs4
	fdiv.s fs2, fs2, ft0
	fadd.s ft0, ft0, fs4
	fdiv.s fs2, fs2, ft0
	
	fadd.s fs3, fs3, fs2	# add current term to final sum
	
	addi t0, t0, 0x1		# inc loop
	addi t1, t1, 0x1		# inc term message
	sb t1, (s2)
	j L1

displayFinal:
	li a7, 60				# load syscall messageDialogFloat
	la a0, msgFinal
	fsgnj.s fa1, fs3, fs3
	ecall
		
	li a7, 10       		# system call for return (0)
	ecall
