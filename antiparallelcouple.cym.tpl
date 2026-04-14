% Single molecule action of eb/kinesin-14 without pseudo
% Here, kinesin-14 is permanently bound to EB3 (very high binding affinity)
% This is to see pushing force generation
% TKC, January 2026

set simul system
{
    time_step = 0.005
    viscosity = 0.02
	display = (style=2;)
}

set space cell
{
    shape = periodic
}

new cell
{
    length = 2.5, 0.5
}

set fiber microtubule
{
    rigidity = 20 
    segmentation = 0.5
    confine = inside, 100, cell
    display = ( line_width=3; )
	binding_key = 1
	
    activity = classic
    growing_speed = 0.075 % from Supplementary infromation Chu et al.
    growing_force = 5 % from Chu et al.
}

set hand strong_hand
{
    unbinding_rate = 0
	unbinding_force = inf
	binding_key = 1
    display = ( color = sky_blue; )
}


set single optical_bead
{
    hand = strong_hand
    activity = fixed
    stiffness = 100 % upper limit of spring constant of optical trap bead, Howard (2001)
	diffusion = 0
}

set single engage
{
	hand = strong_hand
	activity = fixed
	stiffness = 1000
}

set hand kinesin_motor
{
    binding_rate = 5
    binding_range = 0.035 % 0.01 + length of kinesin-14 (Chu et al.)
	binding_key = 1

    unbinding_rate = 4 % Braun et al. k_off for HSET motor
    unbinding_force = 5

    activity = move
    unloaded_speed = -0.035 % from Supplementary infromation Chu et al.
    stall_force = 1.1 % from Reinemann et al.

    display = ( color=red; size=4; )
}

set hand EB
{
    binding_rate = 10
    binding_range = 0.035
	binding_key = 1
    unbinding_rate = 5
	
	%TESTING:
	unbinding_force = 1
	
	activity = track
    bind_only_end = plus_end
    bind_end_range = 0.1 %100nm
	bind_only_growing_end = 1
    track_end = [[0,1]]
    bind_also_end = 1
    display = ( color=green; size=4; )
}

set couple EB3_K14
{
    hand1 = kinesin_motor
    hand2 = EB
	
    diffusion = 0.2 
    stiffness = 42
    length = 0.025
}

new 1 microtubule
% right MT
{
    length = 0.5
    position = 0.3 0.5 0
    orientation = -1 0 0
    attach1 = optical_bead, 0, minus_end
	attach2 = engage, 0, plus_end
	plus_end = grow
}

new 1 microtubule
% left MT
{
	length = 0.5
	position = -0.3 -0.5 0 
    orientation = 1 0 0
    attach1 = optical_bead, 0, minus_end
	attach2 = engage, 0, plus_end
	plus_end = grow
}

new 2000 EB3_K14

run system
{
	nb_steps = 150
}
delete engage
run system
{
	nb_steps = 10
}

run system
{
	nb_steps = 6000
	nb_frames = 500
}

