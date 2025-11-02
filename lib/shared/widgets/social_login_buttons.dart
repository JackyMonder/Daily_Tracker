import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FacebookCircle extends StatelessWidget {
  const FacebookCircle({super.key});

  static const String _fSvg = '<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="100" height="100" viewBox="0 0 50 50">'
    '<path d="M32,11h5c0.552,0,1-0.448,1-1V3.263c0-0.524-0.403-0.96-0.925-0.997C35.484,2.153,32.376,2,30.141,2C24,2,20,5.68,20,12.368 V19h-7c-0.552,0-1,0.448-1,1v7c0,0.552,0.448,1,1,1h7v19c0,0.552,0.448,1,1,1h7c0.552,0,1-0.448,1-1V28h7.222 c0.51,0,0.938-0.383,0.994-0.89l0.778-7C38.06,19.518,37.596,19,37,19h-8v-5C29,12.343,30.343,11,32,11z"></path>'
    '</svg>';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 33,
      height: 33,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF039BE5),
      ),
      child: Center(
        child: SvgPicture.string(_fSvg, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 22, height: 22),
      ),
    );
  }
}

class GoogleCircle extends StatelessWidget {
  const GoogleCircle({super.key});

  static const String _gSvg =
      '<svg width="48" height="48" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">'
      '<path fill="#FFC107" d="M43.611 20.083H42V20H24v8h11.303C33.932 31.91 29.393 35 24 35c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C33.584 5.053 28.971 3 24 3 12.954 3 4 11.954 4 23s8.954 20 20 20 19-8.954 19-20c0-1.341-.138-2.653-.389-3.917z"/>'
      '<path fill="#FF3D00" d="M6.306 14.691l6.571 4.814C14.464 16.103 18.86 13 24 13c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C33.584 5.053 28.971 3 24 3 16.318 3 9.656 7.337 6.306 14.691z"/>'
      '<path fill="#4CAF50" d="M24 43c5.313 0 10.155-2.037 13.79-5.351l-6.363-5.375C29.402 33.447 26.895 34 24 34c-5.37 0-9.897-3.053-12.072-7.497l-6.56 5.05C8.681 38.556 15.814 43 24 43z"/>'
      '<path fill="#1976D2" d="M43.611 20.083H42V20H24v8h11.303c-1.087 3.109-3.293 5.558-6.074 7.017l.001-.001 6.363 5.375C33.117 41.346 38 38 40.95 33.05 42.262 30.773 43 27.995 43 24c0-1.341-.138-2.653-.389-3.917z"/>'
      '</svg>';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(child: SvgPicture.string(_gSvg, width: 22, height: 22)),
    );
  }
}

class AppleCircle extends StatelessWidget {
  const AppleCircle({super.key});

  static const String _aSvg = '<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="100" height="100" viewBox="0 0 50 50">'
  '<path d="M 44.527344 34.75 C 43.449219 37.144531 42.929688 38.214844 41.542969 40.328125 C 39.601563 43.28125 36.863281 46.96875 33.480469 46.992188 C 30.46875 47.019531 29.691406 45.027344 25.601563 45.0625 C 21.515625 45.082031 20.664063 47.03125 17.648438 47 C 14.261719 46.96875 11.671875 43.648438 9.730469 40.699219 C 4.300781 32.429688 3.726563 22.734375 7.082031 17.578125 C 9.457031 13.921875 13.210938 11.773438 16.738281 11.773438 C 20.332031 11.773438 22.589844 13.746094 25.558594 13.746094 C 28.441406 13.746094 30.195313 11.769531 34.351563 11.769531 C 37.492188 11.769531 40.8125 13.480469 43.1875 16.433594 C 35.421875 20.691406 36.683594 31.78125 44.527344 34.75 Z M 31.195313 8.46875 C 32.707031 6.527344 33.855469 3.789063 33.4375 1 C 30.972656 1.167969 28.089844 2.742188 26.40625 4.78125 C 24.878906 6.640625 23.613281 9.398438 24.105469 12.066406 C 26.796875 12.152344 29.582031 10.546875 31.195313 8.46875 Z"></path>'
  '</svg>';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.string(_aSvg, width: 22, height: 22),
      ),
    );
  }
}

class TwitterCircle extends StatelessWidget {
  const TwitterCircle({super.key});

  static const String _tSvg = '<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="100" height="100" viewBox="0 0 30 30">'
  '<path d="M26.37,26l-8.795-12.822l0.015,0.012L25.52,4h-2.65l-6.46,7.48L11.28,4H4.33l8.211,11.971L12.54,15.97L3.88,26h2.65 l7.182-8.322L19.42,26H26.37z M10.23,6l12.34,18h-2.1L8.12,6H10.23z"></path>'
  '</svg>';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.string(_tSvg, width: 22, height: 22),
      ),
    );
  }
}