package com.handchina.ironmine;

import java.applet.AppletContext;
import java.awt.*;
import java.awt.datatransfer.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.*;
import java.text.MessageFormat;
import java.util.Random;
import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.border.TitledBorder;

public class ScreenSaver extends JApplet{
	private static final long serialVersionUID = 0xf305c712d9a7e543L;
	private static final String newline = "\r\n";
	private static final String boundary = Long.toHexString((new Random()).nextLong());
	private static final String ENCODING = "UTF-8";
	private ImagePanel canvas;
	private JButton attachButton;
	
	public ScreenSaver()
	{
		
	}
	
	public void init() {
		setSize(400, 400);
		JPanel mainPanel = new JPanel(new BorderLayout(10, 5), true);
		canvas = new ImagePanel();
		canvas.setBackground(Color.WHITE);
		JScrollPane imageScrollPane = new JScrollPane(canvas, 20, 30);
		imageScrollPane.setBorder(new TitledBorder(getParameter("label.image", "Image")));
		JPanel buttonPane = new JPanel();
		buttonPane.setLayout(new BoxLayout(buttonPane, 2));
		buttonPane.setBorder(BorderFactory.createEmptyBorder(0, 10, 10, 10));
		JButton pasteButton = new JButton(getParameter("label.button.paste", "Paste image from clipboard"));
		pasteButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e)
			{
				pasteImageFromClipboard();
			}
		});
		
		attachButton = new JButton(getParameter("label.button.attach", "Attach"));
		attachButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e)
			{
				attachImage();
			}
		});
		JButton cancelButton = new JButton(getParameter("label.button.cancel", "cancel"));
		cancelButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e)
			{
				closeApplet();
			}
		});
		buttonPane.add(pasteButton);
		buttonPane.add(Box.createHorizontalGlue());
		buttonPane.add(attachButton);
		buttonPane.add(Box.createRigidArea(new Dimension(10, 0)));
		buttonPane.add(cancelButton);
		mainPanel.add(imageScrollPane, "Center");
		mainPanel.add(buttonPane, "South");
		getContentPane().add(mainPanel);
		pasteImageFromClipboard();
    }
	
	private void attachImage()
	{
		try
		{
			String fileId = sendContentToServer(getParameter("attach.url", "http://localhost:3000/attach_screenshot/index"), canvas.getImage());
			getAppletContext().showDocument(new URL((new StringBuilder()).append("javascript:addAttachScreen('").append(fileId).append("');").toString()));
			closeApplet();
		}
		catch (IOException e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, MessageFormat.format(getParameter("error.attach.msg", "Error: {0}"), new Object[] {
				e.getMessage()
			}), getParameter("error.attach.title", "Attaching error"), 0);
		}
	}

	private String sendContentToServer(String url, BufferedImage image)
		throws IOException
	{
		HttpURLConnection urlConn;
		OutputStream outStream;
		URL destURL = new URL(url);
		urlConn = (HttpURLConnection)destURL.openConnection();
		urlConn.setRequestMethod("POST");
		urlConn.setDoOutput(true);
		urlConn.setDoInput(true);
		urlConn.setUseCaches(false);
		urlConn.setAllowUserInteraction(false);
		urlConn.setRequestProperty("Content-type", (new StringBuilder()).append("multipart/form-data; boundary=").append(boundary).toString());
		outStream = urlConn.getOutputStream();
		outStream.write((new StringBuilder()).append("--").append(boundary).append("\r\n").toString().getBytes("UTF-8"));
		outStream.write((new StringBuilder()).append("Content-Disposition: form-data; name=\"key\"\r\n\r\n").append(getParameter("rss.key")).append("\r\n").toString().getBytes("UTF-8"));
		outStream.write((new StringBuilder()).append("--").append(boundary).append("\r\n").toString().getBytes("UTF-8"));
		outStream.write("Content-Disposition: file; name=\"attachments\"; filename=\"screenshot.png\"\r\nContent-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n".getBytes("UTF-8"));
		ImageIO.write(image, "png", outStream);
		outStream.write((new StringBuilder()).append("\r\n--").append(boundary).append("\r\n").toString().getBytes("UTF-8"));
		outStream.close();
		BufferedReader in = new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
		String s = in.readLine();
		System.out.println(s);
		in.close();
		return s;
	}

	private void closeApplet()
	{
		try
		{
			getAppletContext().showDocument(new URL("javascript:hideAttachScreen();"));
		}
		catch (Exception e)
		{
			JOptionPane.showMessageDialog(null, MessageFormat.format(getParameter("error.close.msg", "Can not close applet, {0}"), new Object[] {
				e.getMessage()
			}), getParameter("error.close.title", "Error"), 0);
		}
	}

	private void pasteImageFromClipboard()
	{
		attachButton.setEnabled(false);
		Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
		if (clipboard.isDataFlavorAvailable(DataFlavor.imageFlavor))
		{
			Transferable contents = clipboard.getContents(null);
			if (contents != null)
				try
				{
					if (contents.isDataFlavorSupported(DataFlavor.imageFlavor))
					{
						canvas.setImage((BufferedImage)contents.getTransferData(DataFlavor.imageFlavor));
						attachButton.setEnabled(true);
					}
				}
				catch (UnsupportedFlavorException ufe)
				{
					ufe.printStackTrace();
				}
				catch (IOException ioe)
				{
					ioe.printStackTrace();
				}
		}
	}

	private final String getParameter(String key, String def)
	{
		String param = getParameter(key);
		if (param == null)
			return def;
		else
			return param;
	}
}