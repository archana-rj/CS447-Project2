.include "constants.asm"
.include "macros.asm"

# =================================================================================================
# Bullet
# =================================================================================================

# void bullet_new(x: a0, y: a1, angle: a2)
.globl bullet_new
bullet_new:
enter s0, s1, s2, s3

	move s0, a0 # x
	move s1, a1 # y
	move s2, a2 # angle

	li a0, TYPE_BULLET
	jal Object_new

	move s3, v0

	beq s3 0, _if_loop
		
	sw s0, Object_x(s3) # store x in obj.x
	sw s1, Object_y(s3) # store y in obj.y
	

	li a0, BULLET_THRUST
	move a1, s2
	jal to_cartesian

	sw v0, Object_vx(s3)
	sw v1, Object_vy(s3)

	li t0, BULLET_LIFE
	sw t0, Bullet_frame(s3)

	_if_loop:

leave s0, s1, s2, s3

# ------------------------------------------------------------------------------

.globl bullet_update
bullet_update:
enter s0
	
		move s0, a0

		lw t1, Bullet_frame(s0)
		sub t1, t1, 1
		sw t1, Bullet_frame(s0)

		lw t1, Bullet_frame(s0)
		bne t1, 0, _else_loop

		#move a0, s0
			jal Object_delete

			j _exit_loop
		
	_else_loop:

  		#move a0, s0 
  		jal Object_accumulate_velocity

	  	move a0, s0 
  		jal Object_wrap_position

  	_exit_loop:

leave s0

# ------------------------------------------------------------------------------

.globl bullet_draw
bullet_draw:
enter 

	lw t0, Object_x(a0)
	lw t1, Object_y(a0)

	sra a0, t0, 8
	sra a1, t1, 8
	li a2, COLOR_RED
	jal display_set_pixel

leave 