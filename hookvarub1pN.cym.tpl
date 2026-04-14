% Single molecule action of eb/kinesin-14 with pseudo
% Here, kinesin-14 cannot bind to itself nor can its tail bind to MT
% Varying the unbinding rate and force of EB tail to kinesin tail
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

set fiber pseudo
{
    rigidity = 1
    segmentation = 0.01
    confine = inside, 100, cell
    display = (color = orange; line_width=1;)
    binding_key = 2
	
	min_length = 0.0001 % minimal length possible
	viscosity = 1
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

set single pivot
{
    hand = strong_hand
    activity = fixed
    stiffness = 1000 
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

set hand tail_pseudo
{
    binding_key = 2

    unbinding_rate = 0
    unbinding_force = inf
	
	display = ( color=red; size=2; )
}

set couple kinesin_14cargo
{
    hand1 = tail_pseudo
    hand2 = kinesin_motor
	
    diffusion = 0.2 
    stiffness = 42 % Braun et al. 10^4 kBT um^-2
    length = 0.025
}

set hand EB
{
    binding_rate = 10
    binding_range = 0.01
	binding_key = 1
    unbinding_rate = 2
	
	%TESTING:
	unbinding_force = 1
	
	activity = track
    bind_only_end = plus_end
    bind_end_range = 0.1 %100nm
	bind_only_growing_end = 1
    track_end = 1
    bind_also_end = 1
    display = ( color=green; size=4; )
}

set hand EB100
{
    binding_rate = 10
    binding_range = 0.01
	binding_key = 1
    unbinding_rate = 2
	
	%TESTING:
	unbinding_force = 1
	
	activity = track
    bind_only_end = plus_end
    bind_end_range = 0.1 %100nm
	bind_only_growing_end = 1
    track_end = 0
    bind_also_end = 1
    display = ( color=green; size=4; )
}

set hand EB_tail
{	
	binding_key = 2
	binding_rate = 5
	binding_range = 0.01
	unbinding_force = 10
	
	% TESTING:
	unbinding_rate = [[2, 3, 4, 5, 6]]
	
	bind_also_end = 1
	
	display = ( color=green; size=4; )
}

set couple EB3
{
	hand1 = EB_tail
	hand2 = EB
	diffusion = 0.2
	stiffness = 200
    length = 0
}

set couple bindEB3
{
	hand1 = EB_tail
	hand2 = EB100
	diffusion = 0.2
	stiffness = 200
    length = 0
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

new 1000 EB3
new 1000 bindEB3

new 1000 pseudo
{
    length = 0.001
	position = inside
	%position = rectangle 1 0 0 at 0 0 0
    attach1 = kinesin_14cargo, 0, minus_end
}

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

