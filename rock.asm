.include "constants.asm"
.include "macros.asm"

# =================================================================================================
# Rocks
# =================================================================================================

.globl rocks_count
rocks_count:
enter
	la t0, objects
	li t1, 0
	li v0, 0

	_rocks_count_loop:
		lw t2, Object_type(t0)
		beq t2, TYPE_ROCK_L, _rocks_count_yes
		beq t2, TYPE_ROCK_M, _rocks_count_yes
		bne t2, TYPE_ROCK_S, _rocks_count_continue
		_rocks_count_yes:
			inc v0
	_rocks_count_continue:
	add t0, t0, Object_sizeof
	inc t1
	blt t1, MAX_OBJECTS, _rocks_count_loop
leave

# ------------------------------------------------------------------------------

# void rocks_init(int num_rocks)
.globl rocks_init
rocks_init:
enter s0, s1, s2, s3
	
	move s0, a0 # num of rocks
	li s1, 0 # int i = 0

	_for_loop:

		li a0, 0x2000
		jal random
	
		move s2, v0
		add s2, s2, 0x3000
		rem s2, s2, 0x4000

		li a0, 0x2000
		jal random

		move s3, v0
		add s3, s3, 0x3000
		rem s3, s3, 0x4000

		move a0, s2
		move a1, s3
		li a2, TYPE_ROCK_L
		jal rock_new

		
		add s1, s1, 1 # i++

	blt s1, s0, _for_loop # while i < num rocks

leave s0, s1, s2, s3

# ------------------------------------------------------------------------------

# void rock_new(x, y, type)
rock_new:
enter s0, s1, s2, s3

	move s0, a0 # x
	move s1, a1 # y
	move s2, a2 # type

	move a0, s2
	jal Object_new

	move s3, v0

	sw s0, Object_x(s3) 
	sw s1, Object_y(s3)

	bne s2, TYPE_ROCK_L, _else_loop
		li t0, ROCK_L_HW
		li t1, ROCK_L_HH
		j _exit

	_else_loop:

		bne s2, TYPE_ROCK_M, _else_2_loop
			li t0, ROCK_M_HW
			li t1, ROCK_M_HH
			j _exit

	_else_2_loop:

		bne s2, TYPE_ROCK_S, _else_3_loop

			li t0, ROCK_S_HW
			li t1, ROCK_S_HH
			j _exit

	_else_3_loop:

	_exit:

		sw t0, Object_hw(s3)
		sw t1, Object_hh(s3)

		li a0, 360
		jal random

		bne s2, TYPE_ROCK_L, _vel_loop
			li a0, ROCK_VEL
			j _exit_vel

	_vel_loop:

		bne s2, TYPE_ROCK_M, _vel_2_loop
			li t0, ROCK_VEL
			mul t0, t0, 4
			move a0, t0
			j _exit_vel

	_vel_2_loop:

		bne s2, TYPE_ROCK_S, _vel_3_loop

			li t0, ROCK_VEL
			mul t0, t0, 12
			move a0, t0
			j _exit_vel

	_vel_3_loop:

	_exit_vel:

		move a1, v0
		jal to_cartesian

		sw v0, Object_vx(s3)
		sw v1, Object_vy(s3) 


leave s0, s1, s2, s3

# ------------------------------------------------------------------------------

.globl rock_update
rock_update:
enter
	
	move s0, a0 
  	jal Object_accumulate_velocity

	move a0, s0 
  	jal Object_wrap_position

  	move a0, s0
  	jal rock_collide_with_bullets

leave

# ------------------------------------------------------------------------------

rock_collide_with_bullets:
enter s0, s1, s2

	la s0, objects
	li s1, 0
	move s2, a0 # rock

	_collide_bullets_loop:		
		lw t0, Object_type(s0)
		li t1, TYPE_BULLET	

		bne t0, t1, _if_loop

			move a0, s2
			lw a1, Object_x(s0)
			lw a2, Object_y(s0)
			jal Object_contains_point

				beq v0, 0, _contains_loop

					move a0, s2
					jal rock_get_hit

					move a0, s0
					jal Object_delete
					j _return
	_contains_loop:

	_if_loop:

		add s0, s0, Object_sizeof
		inc s1
		blt s1, MAX_OBJECTS, _collide_bullets_loop

	_return:

leave s0, s1, s2

# ------------------------------------------------------------------------------

rock_get_hit:
enter s0

	move s0, a0

	lw t0, Object_type(s0)
	li t1, TYPE_ROCK_L
	li t2, TYPE_ROCK_M
	li t3, TYPE_ROCK_S	

		bne t0, t1, _if_rock_l

		lw a0, Object_x(s0)
		lw a1, Object_y(s0)
		li a2, TYPE_ROCK_M
		jal rock_new

		lw a0, Object_x(s0)
		lw a1, Object_y(s0)
		li a2, TYPE_ROCK_M
		jal rock_new

		j exit_rock

_if_rock_l:

		bne t0, t2, _if_rock_m

		lw a0, Object_x(s0)
		lw a1, Object_y(s0)
		li a2, TYPE_ROCK_S
		jal rock_new

		lw a0, Object_x(s0)
		lw a1, Object_y(s0)
		li a2, TYPE_ROCK_S
		jal rock_new

		j exit_rock

_if_rock_m:

exit_rock:

	#lw a0, Object_x(s0)
	#lw a1, Object_y(s0)
	#jal explosion_new

	move a0, s0
	jal Object_delete

leave s0

# ------------------------------------------------------------------------------

.globl rock_collide_l
rock_collide_l:
enter
	
	jal rock_get_hit

	li a0, 3
	jal player_damage

leave

# ------------------------------------------------------------------------------

.globl rock_collide_m
rock_collide_m:
enter

	jal rock_get_hit

	li a0, 2
	jal player_damage

leave

# ------------------------------------------------------------------------------

.globl rock_collide_s
rock_collide_s:
enter

	jal rock_get_hit

	li a0, 1
	jal player_damage

leave

# ------------------------------------------------------------------------------

.globl rock_draw_l
rock_draw_l:
enter

	la a1, spr_rock_l
	jal Object_blit_5x5_trans

leave

# ------------------------------------------------------------------------------

.globl rock_draw_m
rock_draw_m:
enter
	
	la a1, spr_rock_m
	jal Object_blit_5x5_trans

leave

# ------------------------------------------------------------------------------

.globl rock_draw_s
rock_draw_s:
enter

	la a1, spr_rock_s
	jal Object_blit_5x5_trans
	
leave