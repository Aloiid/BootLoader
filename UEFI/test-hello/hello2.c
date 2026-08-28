//autre variante 


#include <efi.h>
#include <efilib.h>

EFI_STATUS EFIAPI efi_main(EFI_HANDLE imageID, EFI_SYSTEM_TABLE * SystemTable) {

EFI_SAMPLE_TEXT_OUTPUT_PROTOCOL * conout; 

conout = SystemTable->ConOut; 

SystemTable->ConOut->OutputString(SystemTable->ConOut, L"Hello for the third times Friend. \n"); 

return EFI_SUCESS; 

}
