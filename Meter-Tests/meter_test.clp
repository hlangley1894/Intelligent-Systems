;;; file: meter_test.clp
;;;
;;; written by hayleyl
;;;
;;; purpose: This expert system troubleshoots a meter based on test results.

;; define meter template
	(deftemplate meter
		(slot ID)
		(slot power_cycle
			(allowed-symbols yes intermittently no))
		(slot connected_host
			(allowed-symbols yes no))
		(slot connected_neighbor
			(allowed-symbols yes no))
		(slot powered
			(type FLOAT))
		(slot correct_vals
			(allowed-symbols yes sufficiently no))
		(slot registers_cleared
			(allowed-symbols yes no))
		(slot processed
			(allowed-symbols yes no)))

;; case 1: does meter pass all tests?
	(defrule pass_all
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (power_cycle yes) (connected_host yes)
			(powered ?voltage) (correct_vals yes|sufficiently))
		(test (>= ?voltage 12.0))
=>
		(printout t "Meter " ?meter_id " is ready to ship." crlf)
		(modify ?meter (processed yes)))

;; case 2: did meter turn on after power cycle?
	(defrule power_cycle_fail_no-power
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (power_cycle no) (powered ?voltage))
		(test(< ?voltage 12.0))
=>
		(printout t "Meter " ?meter_id " does not reboot after power cycle due to insufficient power. Be sure the meter is receiving around 12V." crlf)
		(modify ?meter (processed yes)))
		
	(defrule power_cycle_fail_full_power
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (power_cycle no) (powered ?voltage))
		(test(>= ?voltage 12.0))
=>
		(printout t "Meter " ?meter_id " does not reboot after power cycle, but is receiving enough power. Check that reboot signal is reaching meter properly." crlf)
		(modify ?meter (processed yes)))
		
	(defrule power_cycle_intermit
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (power_cycle intermittently))
=>
		(printout t "Meter " ?meter_id " takes several tries to reboot properly. Check that timeout hasn't occurred." crlf)
		(modify ?meter (processed yes)))

;; case 3: is meter connecting to host? connecting to neighbor?
	(defrule host_connect_no_neighbor
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (connected_host no) (connected_neighbor no))
=>
		(printout t "Meter " ?meter_id " is not connecting to host or its neighbor. The wireless card may need to be replaced." crlf)
		(modify ?meter (processed yes)))
		
	(defrule host_connect_neighbor
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (connected_host no) (connected_neighbor yes))
=>
		(printout t "Meter " ?meter_id " is not connecting to host but does ping its neighbor. Move the meter within range of host." crlf)
		(modify ?meter (processed yes)))

;; case 4: is meter receiving suffcient power to operate?
	(defrule sufficient_power
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (powered ?voltage))
		(test (< ?voltage 12.0))
=>
		(printout t "Meter " ?meter_id " is not receiving enough power. Check the power supply is supplying at least 12V." crlf)
		(modify ?meter (processed yes)))	

;; case 5: is meter returning correct voltage values?
	(defrule correct_values_reg_cleared
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (correct_vals no) (registers_cleared yes))
=>
		(printout t "Meter " ?meter_id " is not reporting correct values, but the registers seemed to have been cleared beforehand. The accumulator is malfunctioning and should be replaced." crlf)
		(modify ?meter (processed yes)))	
	
	(defrule correct_values_reg_not_cleared
		?meter <- (meter (ID ?meter_id) (processed no))
		(meter (ID ?meter_id) (correct_vals no) (registers_cleared no))
=>
		(printout t "Meter " ?meter_id " is not reporting correct values and the registers have not been cleared beforehand. Clear the registers and try the test again." crlf)
		(modify ?meter (processed yes)))
		
;;facts
	(deffacts database
		(meter 	(ID 300)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 301) 
				(power_cycle no)
				(connected_host no)
				(connected_neighbor no)
				(powered 12.9)
				(correct_vals no)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 302)
				(power_cycle yes)
				(connected_host no)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 303)
				(power_cycle yes)
				(connected_host no)
				(connected_neighbor no)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared no)
				(processed no))
				
		(meter 	(ID 304)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor no)
				(powered 10.4)
				(correct_vals sufficiently)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 305)
				(power_cycle no)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 3.9)
				(correct_vals no)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 306)
				(power_cycle yes)
				(connected_host no)
				(connected_neighbor no)
				(powered 12.0)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 307)
				(power_cycle intermittently)
				(connected_host yes)
				(connected_neighbor no)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 308)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor no)
				(powered 12.3)
				(correct_vals no)
				(registers_cleared no)
				(processed no))
				
		(meter 	(ID 309)
				(power_cycle yes)
				(connected_host no)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 310)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 311)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))

		(meter 	(ID 312)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 11.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 313)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals sufficiently)
				(registers_cleared no)
				(processed no))
				
		(meter 	(ID 314)
				(power_cycle yes)
				(connected_host no)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 315)
				(power_cycle intermittently)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared no)
				(processed no))
				
		(meter 	(ID 316)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals no)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 317)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 318)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 319)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor yes)
				(powered 2.9)
				(correct_vals yes)
				(registers_cleared yes)
				(processed no))
				
		(meter 	(ID 320)
				(power_cycle yes)
				(connected_host yes)
				(connected_neighbor no)
				(powered 12.9)
				(correct_vals yes)
				(registers_cleared no)
				(processed no))
	)
