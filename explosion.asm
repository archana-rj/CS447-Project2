.include "constants.asm"
.include "macros.asm"

# =================================================================================================
# Explosions
# =================================================================================================

# void explosion_new(x, y)
.globl explosion_new
explosion_new:
enter s0, s1, s2

	move s0, a0 # x
	move s1, a1 # y

	li a0, TYPE_EXPLOSION
	jal Object_new

	move s2, v0
		
	sw s0, Object_x(s2) # store x in obj.x
	sw s1, Object_y(s2) # store y in obj.y

	li t0, EXPLOSION_HW
	sw t0, Object_hw(s2)

	li t1, EXPLOSION_HH
	sw t1, Object_hh(s2)

	li t2, EXPLOSION_ANIM_DELAY
	sw t2, Explosion_timer(s2)

	li t3, 0
	sw t3, Explosion_frame(s2)

leave s0, s1, s2

# ------------------------------------------------------------------------------

.globl explosion_update
explosion_update:
enter

leave

# ------------------------------------------------------------------------------

.globl explosion_draw
explosion_draw:
enter

	#lw t0, Explosion_frame(a0) # i
    #la t1, spr_explosion_frames # A
    #mul t0, t0, 4
    #add t0, t0, t1
    #move a1, t0

	#jal Object_blit_5x5_trans
leave