package CalculationExample {
	import ISQ::*;
	import ScalarFunctions::*;
	
	part def VehiclePart {
		attribute m : MassValue;
	}
	
	part def Vehicle :> VehiclePart;
	
	part vehicle : Vehicle {		
		part eng : VehiclePart;		
		part trans : VehiclePart;
	}
	
	calc def MassSum (partMasses : MassValue[0..*]) totalMass : MassValue {
		sum(partMasses)
	}
	
	calc ms: MassSum (
		partMasses = (vehicle.eng.m, vehicle.trans.m))
		totalMass = vehicle.m;
		
	calc def MassSum1 {
		in partMasses : MassValue[0..*];
		return totalMass : MassValue = sum(partMasses);
	}
	
	calc ms1: MassSum {
		in partMasses = (vehicle.eng.m, vehicle.trans.m);
		return totalMass = vehicle.m;
	}
	
	part vehicles[*] = (vehicle, vehicle);
	attribute masses1[*] = (vehicles as VehiclePart).m;
	attribute masses2[*] = (vehicles as vehicle).m;
}