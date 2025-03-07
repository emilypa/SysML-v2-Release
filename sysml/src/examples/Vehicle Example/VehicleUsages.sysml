/**
 * Example usages of elements from the vehicle definitions model.
 **/
package VehicleUsages {
	import SI::N;
	import SI::m;
	import VehicleDefinitions::*;
	import ScalarFunctions::*;

	/* VALUES */	 
	T1 = 10.0 [N * m];
	T2 = 20.0 [N * m];
	
	/* PARTS */	
	/** Narrow-rim wheel configuration with 4 to 5 lugbolts. **/
	part narrowRimWheel: Wheel {
		part lugbolt: Lugbolt[4..5];
	}
	
	/** Wide-rim wheel configuration with 4 to 6 lugbolts. **/	
	part wideRimWheel: Wheel {
		part lugbolt: Lugbolt[4..6];
	}

	/** Basic Vehicle configuration showing a part hierarchy. **/
	part vehicle_C1: Vehicle {
		part frontAxleAssembly: AxleAssembly {
			part frontWheel[2] subsets narrowRimWheel {
				part redefines lugbolt[4] {
					attribute redefines tighteningTorque = T1;
				}
			}
			part frontAxle: Axle;
		}		
		part rearAxleAssembly: AxleAssembly {
			part rearWheel[2] subsets wideRimWheel {
				part redefines lugbolt[6] {
					attribute redefines tighteningTorque = T2;
				}
			}
			part rearAxle: Axle;			
		}
	}
	
	/** Specialized configuration with part-specific ports. **/
	part vehicle_C2 subsets vehicle_C1 {
		part redefines frontAxleAssembly {
			part leftFrontWheel subsets frontWheel = frontWheel[1];
			part rightFrontWheel subsets frontWheel = frontWheel[2];
			
			interface leftFrontMount: Mounting connect 
				frontAxle.leftMountingPoint to leftFrontWheel.hub;
				
			interface rightFrontMount: Mounting connect 
				frontAxle.rightMountingPoint to rightFrontWheel.hub;
		}
		
		part rearAxleAssembly redefines vehicle_C1::rearAxleAssembly {
			part leftRearWheel subsets rearWheel = rearWheel[1];
			part rightRearWheel subsets rearWheel = rearWheel[2];

			interface leftRearMount: Mounting connect 
				rearAxle.leftMountingPoint to leftRearWheel.hub;
				
			interface rightRearMount: Mounting connect 
				rearAxle.rightMountingPoint to rightRearWheel.hub;
		}		
	}
	
	/** Further specialized configuration with a connection to a deeply-nested port. **/
	part vehicle_C3 subsets vehicle_C2 {
		
		part transmission: Transmission {
			port drive: ~DriveIF;
		}
		
		part redefines rearAxleAssembly {
			part redefines rearAxle {
				port drive: DriveIF;
			}
		}
		
		interface driveShaft connect 
			transDrive :> transmission.drive to axleDrive :> rearAxleAssembly.rearAxle.drive {
			flow transDrive.driveTorque to axleDrive.driveTorque;
		}		
	}
}