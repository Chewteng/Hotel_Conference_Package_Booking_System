import 'package:flutter/material.dart';

class EulaDialog extends StatefulWidget {
  final Function toggleEula;

  EulaDialog({@required this.toggleEula});

  @override
  _EulaDialogState createState() => _EulaDialogState();
}

class _EulaDialogState extends State<EulaDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'End User License Agreement',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 23,
        ),
      ),
      content: SingleChildScrollView(
        
        child: Column(
          children: <Widget>[
            Text(
                '\nCP Hotel Booking 1.0\nCopyright (c) 2021 Hngcteng\n\n*** END USER LICENSE AGREEMENT ***\n\nIMPORTANT: PLEASE READ THIS LICENSE CAREFULLY BEFORE USING THIS SOFTWARE.\n\n1. LICENSE\n\nBy receiving, opening the file package, and/or using CP Hotel Booking 1.0 ("Software") containing this software, you agree that this End User User License Agreement (EULA) is a legally binding and valid contract and agree to be bound by it. You agree to abide by the intellectual property laws and all of the terms and conditions of this Agreement.\n\nUnless you have a different license agreement signed by Hngcteng your use of CP Hotel Booking 1.0 indicates your acceptance of this license agreement and warranty.\n\nSubject to the terms of this Agreement, CP Hotel Booking grants to you a limited, non-exclusive, non-transferable license, without right to sub-license, to use CP Hotel Booking 1.0 in accordance with this Agreement and any other written agreement with Hngcteng. Hngcteng does not transfer the title of CP Hotel Booking 1.0 to you; the license granted to you is not a sale. This agreement is a binding legal agreement between Hngcteng and the purchasers or users of CP Hotel Booking 1.0.\n\nIf you do not agree to be bound by this agreement, remove CP Hotel Booking 1.0 from your computer now and, if applicable, promptly return to Hngcteng by mail any copies of CP Hotel Booking 1.0 and related documentation and packaging in your possession.\n\n2. DISTRIBUTION\n\nCP Hotel Booking 1.0 and the license herein granted shall not be copied, shared, distributed, re-sold, offered for re-sale, transferred or sub-licensed in whole or in part except that you may make one copy for archive purposes only. For information about redistribution of CP Hotel Booking 1.0 contact Hngcteng.\n\n3. USER AGREEMENT\n\n3.1 Use\n\nYour license to use CP Hotel Booking 1.0 is limited to the number of licenses purchased by you. You shall not allow others to use, copy or evaluate copies of CP Hotel Booking 1.0.\n\n3.2 Use Restrictions\n\nYou shall use CP Hotel Booking 1.0 in compliance with all applicable laws and not for any unlawful purpose. Without limiting the foregoing, use, display or distribution of CP Hotel Booking 1.0 together with material that is pornographic, racist, vulgar, obscene, defamatory, libelous, abusive, promoting hatred, discriminating or displaying prejudice based on religion, ethnic heritage, race, sexual orientation or age is strictly prohibited.\n\nEach licensed copy of CP Hotel Booking 1.0 may be used on one single computer location by one user. Use of CP Hotel Booking 1.0 means that you have loaded, installed, or run CP Hotel Booking 1.0 on a computer or similar device. If you install CP Hotel Booking 1.0 onto a multi-user platform, server or network, each and every individual user of CP Hotel Booking 1.0 must be licensed separately.\n\nYou may make one copy of CP Hotel Booking 1.0 for backup purposes, providing you only have one copy installed on one computer being used by one person. Other users may not use your copy of CP Hotel Booking 1.0 . The assignment, sublicense, networking, sale, or distribution of copies of CP Hotel Booking 1.0 are strictly forbidden without the prior written consent of Hngcteng. It is a violation of this agreement to assign, sell, share, loan, rent, lease, borrow, network or transfer the use of CP Hotel Booking 1.0. If any person other than yourself uses CP Hotel Booking 1.0 registered in your name, regardless of whether it is at the same time or different times, then this agreement is being violated and you are responsible for that violation!\n\n3.3 Copyright Restriction\n\nThis Software contains copyrighted material, trade secrets and other proprietary material. You shall not, and shall not attempt to, modify, reverse engineer, disassemble or decompile CP Hotel Booking 1.0. Nor can you create any derivative works or other works that are based upon or derived from CP Hotel Booking 1.0 in whole or in part.\n\nHngcteng\'s name, logo and graphics file that represents CP Hotel Booking 1.0 shall not be used in any way to promote products developed with CP Hotel Booking 1.0 . Hngcteng retains sole and exclusive ownership of all right, title and interest in and to CP Hotel Booking 1.0 and all Intellectual Property rights relating thereto.\n\nCopyright law and international copyright treaty provisions protect all parts of CP Hotel Booking 1.0, products and services. No program, code, part, image, audio sample, or text may be copied or used in any way by the user except as intended within the bounds of the single user program. All rights not expressly granted hereunder are reserved for Hngcteng.\n\n3.4 Limitation of Responsibility\n\nYou will indemnify, hold harmless, and defend Hngcteng, its employees, agents and distributors against any and all claims, proceedings, demand and costs resulting from or in any way connected with your use of Hngcteng\'s Software.\n\nIn no event (including, without limitation, in the event of negligence) will Hngcteng , its employees, agents or distributors be liable for any consequential, incidental, indirect, special or punitive damages whatsoever (including, without limitation, damages for loss of profits, loss of use, business interruption, loss of information or data, or pecuniary loss), in connection with or arising out of or related to this Agreement, CP Hotel Booking 1.0 or the use or inability to use CP Hotel Booking 1.0 or the furnishing, performance or use of any other matters hereunder whether based upon contract, tort or any other theory including negligence.\n\nHngcteng\'s entire liability, without exception, is limited to the customers\' reimbursement of the purchase price of the Software (maximum being the lesser of the amount paid by you and the suggested retail price as listed by Hngcteng ) in exchange for the return of the product, all copies, registration papers and manuals, and all materials that constitute a transfer of license from the customer back to Hngcteng.\n\n3.5 Warranties\n\nExcept as expressly stated in writing, Hngcteng makes no representation or warranties in respect of this Software and expressly excludes all other warranties, expressed or implied, oral or written, including, without limitation, any implied warranties of merchantable quality or fitness for a particular purpose.\n\n3.6 Governing Law\n\nThis Agreement shall be governed by the law of the Malaysia applicable therein. You hereby irrevocably attorn and submit to the non-exclusive jurisdiction of the courts of Malaysia therefrom. If any provision shall be considered unlawful, void or otherwise unenforceable, then that provision shall be deemed severable from this License and not affect the validity and enforceability of any other provisions.\n\n3.7 Termination\n\nAny failure to comply with the terms and conditions of this Agreement will result in automatic and immediate termination of this license. Upon termination of this license granted herein for any reason, you agree to immediately cease use of CP Hotel Booking 1.0 and destroy all copies of CP Hotel Booking 1.0 supplied under this Agreement. The financial obligations incurred by you shall survive the expiration or termination of this license.\n\n4. DISCLAIMER OF WARRANTY\n\nTHIS SOFTWARE AND THE ACCOMPANYING FILES ARE SOLD "AS IS" AND WITHOUT WARRANTIES AS TO PERFORMANCE OR MERCHANTABILITY OR ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED. THIS DISCLAIMER CONCERNS ALL FILES GENERATED AND EDITED BY CP Hotel Booking 1.0 AS WELL.\n\n5. CONSENT OF USE OF DATA\n\nYou agree that Hngcteng may collect and use information gathered in any manner as part of the product support services provided to you, if any, related to CP Hotel Booking 1.0.Hngcteng may also use this information to provide notices to you which may be of use or interest to you.'),
            SizedBox(height: 8),
            RaisedButton(
            
              color: Colors.blue[400],
              child: Text('I accept the terms of the EULA',style: TextStyle(
                        //fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
                widget.toggleEula(boolean: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}