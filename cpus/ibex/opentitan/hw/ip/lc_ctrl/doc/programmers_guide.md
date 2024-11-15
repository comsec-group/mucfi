# Programmer's Guide

The register layout and offsets shown in the [register table](../data/lc_ctrl.hjson#registers) below are identical for both the CSR and JTAG TAP interfaces.
Hence the following programming sequence applies to both SW running on the device and SW running on the test appliance that accesses life cycle through the TAP.

1. In order to perform a life cycle transition, SW should first check whether the life cycle controller has successfully initialized and is ready to accept a transition command by making sure that the [`STATUS.READY`](../data/lc_ctrl.hjson#status) bit is set to 1, and that all other status and error bits in [`STATUS`](../data/lc_ctrl.hjson#status) are set to 0.

2. Read the [`LC_STATE`](../data/lc_ctrl.hjson#lc_state) and [`LC_TRANSITION_CNT`](../data/lc_ctrl.hjson#lc_transition_cnt) registers to determine which life cycle state the device currently is in, and how many transition attempts are still available.

3. Claim exclusive access to the transition interface by writing kMuBi8True to the [`CLAIM_TRANSITION_IF`](../data/lc_ctrl.hjson#claim_transition_if) register, and reading it back. If the value read back equals to kMuBi8True, the hardware mutex has successfully been claimed and SW can proceed to step 4. If the value read back equals to 0, the mutex has already been claimed by the other interface (either CSR or TAP), and SW should try claiming the mutex again.
Note that all transition interface registers are protected by the hardware-governed [`TRANSITION_REGWEN`](../data/lc_ctrl.hjson#transition_regwen) register, which will only be set to 1 if the mutex has been claimed successfully.

4. If required, enable the external clock and other vendor-specific OTP settings in the [`OTP_VENDOR_TEST_CTRL`](../data/lc_ctrl.hjson#otp_vendor_test_ctrl) register.
Note that these settings only take effect in RAW, TEST* and RMA life cycle states.
They are ignored in the PROD* and DEV states.

5. Write the desired target state to [`TRANSITION_TARGET`](../data/lc_ctrl.hjson#transition_target). For conditional transitions, the corresponding token has to be written to [`TRANSITION_TOKEN_0`](../data/lc_ctrl.hjson#transition_token_0). For all unconditional transitions, the token registers have to be set to zero.

6. An optional, but recommended step is to read back and verify the values written in steps 4. and 5. before proceeding with step 7.

7. Write 1 to the [`TRANSITION_CMD.START`](../data/lc_ctrl.hjson#transition_cmd) register to initiate the life cycle transition.

8. Poll the [`STATUS`](../data/lc_ctrl.hjson#status) register and wait until either [`STATUS.TRANSITION_SUCCESSFUL`](../data/lc_ctrl.hjson#status) or any of the error bits is asserted.
The [`TRANSITION_REGWEN`](../data/lc_ctrl.hjson#transition_regwen) register will be set to 0 while a transition is in progress in order to prevent any accidental modifications of the transition interface registers during this phase.

Note that any life cycle state transition - no matter whether successful or not - increments the LC_TRANSITION_CNT and moves the life cycle state into the temporary POST_TRANSITION state.
Hence, step 8. cannot be carried out in case device SW is used to implement the programming sequence above, since the processor is disabled in the POST_TRANSITION life cycle state.

This behavior is however not of concern, since access to the transition interface via the CSRs is considered a convenience feature for bringup in the lab.
It is expected that the JTAG TAP interface is used to access the life cycle transition interface in production settings.

## Device Interface Functions (DIFs)

- [Device Interface Functions](../../../../sw/device/lib/dif/dif_lc_ctrl.h)

## Register Table

* [Register Table](../data/lc_ctrl.hjson#registers)
