/** @noSelf */
declare class GyroscopicPropellerPeripheral implements IPeripheral {
	/**
	 * Get the installed manual target as a world-frame unit-length direction vector,
	 * or undefined if the bearing is currently gravity-tracking.
	 */
	getManualTarget(): [number, number, number] | undefined;

	/**
	 * Install a persistent manual target direction.
	 */
	setManualTarget(target: [number, number, number]): void;

	/**
	 * Remove any manual target, returning the bearing to default gravity-tracking behavior.
	 */
	clearManualTarget(): void;

	/**
	 * Get the bearing's mounted-facing direction as a unit vector.
	 */
	getBlockNormal(): [number, number, number];

	/**
	 * Angle between the current thrust direction and the bearing's mounted-facing direction, in degrees.
	 */
	getTiltAngle(): number;

	/**
	 * Effective stabilization gain in [0, 1].
	 */
	getStabilizationStrength(): number;

	/**
	 * Get the bearing's mounted direction name, or undefined if unavailable.
	 */
	getAxis(): string | undefined;

	/**
	 * Get the bearing's thrust direction vector.
	 */
	getThrustVector(): [number, number, number];

	/**
	 * Get the bearing's facing direction vector.
	 */
	getFacingVector(): [number, number, number];

	/**
	 * Get the bearing's rotation speed.
	 */
	getRotationSpeed(): number;

	/**
	 * Get the bearing's angular speed.
	 */
	getAngularSpeed(): number;

	/**
	 * Get the bearing's current visual angle.
	 */
	getAngle(): number;

	/**
	 * Get the bearing's current thrust output.
	 */
	getThrust(): number;

	/**
	 * Get the bearing's current airflow.
	 */
	getAirflow(): number;

	/**
	 * Get the bearing's total sail power.
	 */
	getSailPower(): number;

	/**
	 * Check whether the bearing is currently active.
	 */
	isActive(): boolean;

	/**
	 * Get the bearing's thrust handedness.
	 */
	getThrustHandedness(): "right_handed" | "left_handed";

	/**
	 * Set the bearing's thrust handedness.
	 */
	setThrustHandedness(handedness: "right_handed" | "left_handed"): void;

	/**
	 * Check whether the bearing has assembled a contraption.
	 */
	isAssembled(): boolean;

	/**
	 * Assemble the bearing's contraption.
	 */
	assemble(): void;

	/**
	 * Disassemble the bearing's contraption.
	 */
	disassemble(): void;

	/**
	 * Check whether the bearing has a wooden top variant.
	 */
	isWoodenTop(): boolean;

	/**
	 * Get this block's id.
	 */
	getSelfId(): string;

	/**
	 * Get the id of the block immediately driving this one, or undefined if no source exists.
	 */
	getSourceId(): string | undefined;

	/**
	 * Get the id of this block's speed-zone anchor.
	 */
	getSubnetworkAnchorId(): string | undefined;

	/**
	 * Get the id of this block's kinetic network.
	 */
	getNetworkId(): string | undefined;

	/**
	 * Get this block's role on the kinetic graph.
	 */
	getKind(): "generator" | "split_shaft" | "consumer" | "passthrough";

	/**
	 * Get the local rotational speed at this block.
	 */
	getSpeed(): number;

	/**
	 * Check whether this block is connected to a kinetic source.
	 */
	hasSource(): boolean;

	/**
	 * Check whether the block's network is overstressed.
	 */
	isOverstressed(): boolean;

	/**
	 * Get the stress impact of this block on its network.
	 */
	getStressImpact(): number;

	/**
	 * Get this block's contribution to its network's stress capacity.
	 */
	getStressContribution(): number;
}

/** @noSelf */
declare class NavigationTablePeripheral implements IPeripheral {
	/**
	 * Check whether the nav table has resolved a live target.
	 */
	hasTarget(): boolean;

	/**
	 * Get the registry id of the held nav-table item type.
	 */
	getTargetType(): string | undefined;

	/**
	 * Get item-specific metadata for the held nav-table item.
	 */
	getTargetMetadata(): Record<string, unknown>;

	/**
	 * Get the raw relative angle to the target, in degrees.
	 */
	getRelativeAngle(): number;

	/**
	 * Get the raw relative angle to the target, in radians.
	 */
	getRelativeAngleRad(): number;

	/**
	 * Get the forward-error bearing to the target, in degrees.
	 */
	getBearing(): number;

	/**
	 * Get the forward-error bearing to the target, in radians.
	 */
	getBearingRad(): number;

	/**
	 * Get the distance to the resolved target.
	 */
	getDistanceToTarget(): number;

	/**
	 * Get the rate at which the table is closing on the target.
	 */
	getClosureRate(): number;

	/**
	 * Get the signed vertical offset between the target and the table's projected position.
	 */
	getVerticalOffsetToTarget(): number;

	/**
	 * Get the host sub-level's orientation as a quaternion [x, y, z, w].
	 */
	getOrientation(): [number, number, number, number];

	/**
	 * Get the host sub-level's heading in degrees.
	 */
	getHeading(): number;

	/**
	 * Get the host sub-level's heading in radians.
	 */
	getHeadingRad(): number;
}
