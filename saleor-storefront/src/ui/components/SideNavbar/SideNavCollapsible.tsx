"use client";
import { type ReactNode, useState } from "react";
import { ChevronDown } from "lucide-react";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";

export function NavCollapsible({ children }: { children: ReactNode }) {
	const [open, setOpen] = useState(false);

	return (
		<Collapsible open={open} onOpenChange={setOpen}>
			{children}
		</Collapsible>
	);
}

export function NavCollapsibleTrigger({ children }: { children: ReactNode }) {
	return (
		<CollapsibleTrigger asChild>
			<div className="group flex flex-1 items-center justify-between transition-all [&[data-state=open]>svg]:rotate-180">
				{children}
				<ChevronDown className="h-4 w-4 shrink-0 text-inherit transition-transform duration-200" />
			</div>
		</CollapsibleTrigger>
	);
}
export function NavCollapsibleContent({ children }: { children: ReactNode }) {
	return <CollapsibleContent className="">{children}</CollapsibleContent>;
}
