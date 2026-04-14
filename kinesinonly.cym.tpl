% Recreating pulling force - simulating optical artificial spindle assay from Chu et al. - kinesin only system
% Single-molecule action of kinesin-14
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
    unbinding_force = 2

    activity = move
    unloaded_speed = -0.035 % from Supplementary infromation Chu et al.
    stall_force = 1.1 % from Reinemann et al.

    display = ( color=red; size=4; )
}

set hand tail_MT
% Can bind to either MT or the tail of another kinesin
{
	binding_rate = 5
    binding_range = 0.035

    unbinding_rate = 0.01 % Braun et al. tail-dominated diffusivity
    unbinding_force = 2
	
	bind_also_end = 1
	
	display = ( color=red; size=2; )
}

set couple kinesin_14MT
{
    hand1 = kinesin_motor
    hand2 = tail_MT
	
    diffusion = 0.2 
    stiffness = 42 % Braun et al. 10^4 kBT um^-2
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

new 100 kinesin_14MT

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
