
CREATE TABLE [dbo].[SignatureRequestsMailLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Request] [varchar](max) NULL,
	[Response] [varchar](max) NULL,
	[Status] [varchar](10) NOT NULL,
	[SendDate] [datetime] NOT NULL,
	[ClientId] [varchar](50) NULL
)

GO

CREATE VIEW [dbo].[SignatureRequestsMail]
AS
SELECT s.ClientId, 
	   s.DocumentType, 
	   ee.EMail,
	   c.MailingPreference
FROM SignatureRequests s
   , DocumentsVt vt
   , Policies p
   , StatusPols e
   , EMailsEncrypt ee
   , Clients C
WHERE CONVERT(FLOAT, S.PolicyNumber) = CONVERT(FLOAT, VT.sOfficialPol)   
  AND CONVERT(FLOAT, S.PolicyNumber) = CONVERT(FLOAT, P.PolicyNumber)--
  AND P.CLIENTID = C.CLIENTID
  AND ee.CLIENTID = P.CLIENTID
  AND C.ClientId = S.ClientId
  AND S.DocumentType = VT.ncrthecni
  AND VT.dNulldate IS NULL /* Solo se toma el ultimo registro vigente de la tabla VT*/
  AND (S.DocumentType = 5 OR (S.DocumentType BETWEEN 101 and 250))
  AND S.PolicyStatus is NULL /* Nunca la poliza pasó a estar inactiva*/
  AND P.PolicyNumber like '0%'
  
  AND P.StatusDesc = E.Status 
  AND E.IsDeleted = 0 /* Estados Habilitados*/
  AND E.IsActive = 1  /* Solo polizas activas*/

  AND (S.SignatureOnlineStatus = 'Pendiente' OR S.SignatureOnlineStatus IS NULL)
  AND (S.SignatureInPersonStatus = 'Pendiente' OR S.SignatureInPersonStatus IS NULL)
  AND dbo.DocumentState(S.PolicyNumber, s.DocumentType) = 'Pendiente'
  AND S.ProcedureNumber is NULL /* No se han firmado anteriormente */
  AND S.DestinationContent = 'TOMADOR'

  AND DATEADD(DAY, 7, vt.dDocdate) <= GETDATE()  
  
GO

INSERT INTO EMailsTemplates
VALUES 
(53, 'Prudential Seguros - Documentación con requerimiento de firma',
'<p>Estimado cliente:</p>
<p>Te informamos que se encuentra disponible en el sitio nueva documentación que requiere tu aceptación.</p>
</p><b>IMPORTANTE: La vigencia de la póliza está condicionada a la aceptación de esta documentación.</b></p>
<p>Si todavía no tenés tu cuenta online, creala entrando a <a href="https://clientes.prudentialseguros.com.ar">https://clientes.prudentialseguros.com.ar</a>, opción "¿Nuevo en el sitio?" y seguí las instrucciones. Recordá que, de ahora en más, recibirás todas nuestras comunicaciones por vía digital.</p>
<p>Ante cualquier inconveniente no dudes en contactarnos vía e-mail a <a href="mailto:atencionalasegurado@prudential.com">atencionalasegurado@prudential.com</a>  o bien telefónicamente a la siguiente línea gratuita: 0-800-777-PRUD(7783)</p>
<p>Muchas gracias</p>
<p>Prudential Seguros S.A.</p>', 0)

INSERT INTO EMailsTemplates
VALUES 
(54, 'Prudential Seguros - Documentación con requerimiento de firma',
'<p>Estimado cliente:</p>
<p>Te informamos que se encuentra disponible en el sitio nueva documentación que requiere tu aceptación.</p>
<p>Si todavía no tenés tu cuenta online, creala entrando a <a href="https://clientes.prudentialseguros.com.ar">https://clientes.prudentialseguros.com.ar</a>, opción "¿Nuevo en el sitio?" y seguí las instrucciones. Recordá que, de ahora en más, recibirás todas nuestras comunicaciones por vía digital.</p>
<p>Ante cualquier inconveniente no dudes en contactarnos vía e-mail a <a href="mailto:atencionalasegurado@prudential.com">atencionalasegurado@prudential.com</a>  o bien telefónicamente a la siguiente línea gratuita: 0-800-777-PRUD(7783)</p>
<p>Muchas gracias</p>
<p>Prudential Seguros S.A.</p>', 0)

INSERT INTO EMailsTemplates
VALUES
(55, 'Prudential Seguros - Documentación con requerimiento de firma',
'<p>Estimado cliente:</p>
<p>Te informamos que se encuentra disponible en el sitio nueva documentación que requiere tu aceptación.</p>
</p><b>IMPORTANTE: La vigencia de las pólizas está condicionada a la aceptación de esta documentación.</b></p>
<p>Si todavía no tenés tu cuenta online, creala entrando a <a href="https://clientes.prudentialseguros.com.ar">https://clientes.prudentialseguros.com.ar</a>, opción "¿Nuevo en el sitio?" y seguí las instrucciones. Recordá que, de ahora en más, recibirás todas nuestras comunicaciones por vía digital.</p>
<p>Ante cualquier inconveniente no dudes en contactarnos vía e-mail a <a href="mailto:atencionalasegurado@prudential.com">atencionalasegurado@prudential.com</a>  o bien telefónicamente a la siguiente línea gratuita: 0-800-777-PRUD(7783)</p>
<p>Muchas gracias</p>
<p>Prudential Seguros S.A.</p>', 0)