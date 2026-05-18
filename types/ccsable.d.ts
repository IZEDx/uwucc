/**
 * A basic quaternion type and some common quaternion operations.
 * @see https://techtastic.github.io/Advanced-Math/modules/quaternion.html
 */
declare class Quaternion {
	constructor(v: Vector, a: number);

	static fromAxisAngle(axis: Vector, angle: number): Quaternion;

	static fromEuler(pitch: number, yaw: number, roll: number): Quaternion;

	static fromComponents(x: number, y: number, z: number, w: number): Quaternion;

	static fromMatrix(m: Matrix): Quaternion;

	static identity(): Quaternion;

	/**
	 * The imaginary/vector component.
	 */
	v: Vector;

	/**
	 * The real/scalar component.
	 */
	a: number;

	/**
	 * Adds two quaternions together.
	 * Does not normalize the result.
	 */
	add(other: Quaternion): Quaternion;

	/**
	 * Subtracts two quaternions.
	 * Does not normalize the result.
	 */
	sub(other: Quaternion): Quaternion;

	/**
	 * Quaternion multiplication overloads.
	 */
	mul(other: number): Quaternion;
	mul(other: Quaternion): Quaternion;
	mul(other: Vector): Vector;

	/**
	 * Divides by a scalar or quaternion.
	 */
	div(other: number): Quaternion;
	div(other: Quaternion): Quaternion;

	/**
	 * Negates the quaternion.
	 */
	unm(): Quaternion;

	/**
	 * String representation:
	 * "w + xi + yj + zk"
	 */
	tostring(): string;

	/**
	 * Equality comparison.
	 */
	equals(other: Quaternion): boolean;

	/**
	 * Quaternion conjugate.
	 */
	conjugate(): Quaternion;

	/**
	 * Returns a normalized quaternion.
	 */
	normalize(): Quaternion;

	/**
	 * Computes the inverse quaternion.
	 */
	inverse(): Quaternion;

	/**
	 * Spherical linear interpolation.
	 */
	slerp(other: Quaternion, alpha: number): Quaternion;

	/**
	 * Rotation angle in radians.
	 */
	getAngle(): number;

	/**
	 * Normalized rotation axis.
	 */
	getAxis(): Vector;

	/**
	 * Converts to Euler angles using YXZ order.
	 */
	toEuler(): LuaMultiReturn<[number, number, number]>;

	/**
	 * Quaternion magnitude.
	 */
	length(): number;

	/**
	 * True if any component is NaN.
	 */
	isNan(): boolean;

	/**
	 * True if any component is infinite.
	 */
	isInf(): boolean;

	/**
	 * Deep copy.
	 */
	copy(): Quaternion;
}

type Matrix = {};

/**
 * @see https://techtastic.github.io/CC-Sable/modules/sublevel.html
 */
declare namespace sublevel {
	export interface Pose {
		position: Vector;
		orientation: Quaternion;
		scale: Vector;
		rotationPoint: Vector;
	}

	/** @noSelf */
	export function isInPlotGrid(): boolean;

	/** @noSelf */
	export function getUniqueId(): string;

	/** @noSelf */
	export function getName(): string;

	/** @noSelf */
	export function setName(newName: string): void;

	/** @noSelf */
	export function getLogicalPose(): Pose;

	/** @noSelf */
	export function getLastPose(): Pose;

	/** @noSelf */
	export function getVelocity(): Vector;

	/** @noSelf */
	export function getLinearVelocity(): Vector;

	/** @noSelf */
	export function getAngularVelocity(): Vector;

	/** @noSelf */
	export function getCenterOfMass(): Vector;

	/** @noSelf */
	export function getMass(): number;

	/** @noSelf */
	export function getInverseMass(): number;

	/** @noSelf */
	export function getInertiaTensor(): Matrix;

	/** @noSelf */
	export function getInverseInertiaTensor(): Matrix;
}

/**
 * @see https://techtastic.github.io/CC-Sable/modules/aero.html
 */
declare namespace aero {
	export interface PhysicsInfo {
		baseGravity: Vector;
		basePressure: number;
		magneticNorth: Vector;
		universalDrag: number;
		airPressureFunction?: unknown;
	}

	/** @noSelf */
	export function getAirPressure(position: Vector): number;

	/** @noSelf */
	export function getGravity(): Vector;

	/** @noSelf */
	export function getMagneticNorth(): Vector;

	/** @noSelf */
	export function getUniversalDrag(): number;

	/** @noSelf */
	export function getRaw(): PhysicsInfo;

	/** @noSelf */
	export function getDefault(): PhysicsInfo;
}
