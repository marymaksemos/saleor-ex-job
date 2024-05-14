"use client";
import { type ButtonHTMLAttributes } from "react";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {}

export function Button({ children, ...props }: ButtonProps) {
	return (
		<button
			{...props}
			className="border-2 border-black bg-white px-12 py-2.5 font-semibold capitalize text-black shadow-[7px_7px_0px_0px_black] transition-all duration-700 hover:bg-black hover:text-white hover:shadow-[7px_7px_0px_0px_#3b82f6] hover:transition-all hover:duration-700"
		>
			{children}
		</button>
	);
}
